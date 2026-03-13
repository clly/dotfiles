# Design Principles — Detailed Reference

This file contains expanded explanations and before/after code examples for each principle
referenced in the main SKILL.md. Examples are in Go and Python but the ideas are universal.

---

## 1. Single Responsibility

**The idea:** Each module, struct, or function should have one reason to change. When a unit
does multiple unrelated things, a change to one concern risks breaking the others, and readers
have to hold the entire thing in their head at once.

**When it helps:** Services, handlers, and business logic layers — anywhere mixed concerns
create coupling between things that evolve independently (e.g., validation rules vs. database
schema vs. notification channels).

**When to ease up:** Small scripts, CLI tools, and glue code where the overhead of
decomposition exceeds the benefit. A 40-line main() that reads a file, transforms it, and
writes it out is fine as a single function.

### Example (Go)

**Before — one function owns everything:**

```go
func CreateUser(name, email string) error {
    // Validation
    if name == "" || !strings.Contains(email, "@") {
        log.Println("validation failed")
        return errors.New("invalid input")
    }
    // Persistence
    db, _ := sql.Open("postgres", connStr)
    _, err := db.Exec("INSERT INTO users (name, email) VALUES ($1, $2)", name, email)
    if err != nil {
        log.Println("db error:", err)
        return err
    }
    // Notification
    smtp.SendMail(smtpAddr, auth, from, []string{email}, []byte("Welcome!"))
    log.Println("user created:", email)
    return nil
}
```

If you change the email provider, you're editing the same function that handles DB writes.
If validation rules evolve, you're touching code adjacent to SMTP config.

**After — each concern is a separate, testable unit:**

```go
type UserValidator struct{}

func (v *UserValidator) Validate(name, email string) error {
    if name == "" {
        return errors.New("name is required")
    }
    if !strings.Contains(email, "@") {
        return errors.New("invalid email")
    }
    return nil
}

type UserRepo struct{ db *sql.DB }

func (r *UserRepo) Save(name, email string) error {
    _, err := r.db.Exec("INSERT INTO users (name, email) VALUES ($1, $2)", name, email)
    return err
}

type UserService struct {
    validator *UserValidator
    repo      *UserRepo
    notifier  Notifier
}

func (s *UserService) Create(name, email string) error {
    if err := s.validator.Validate(name, email); err != nil {
        return fmt.Errorf("validation: %w", err)
    }
    if err := s.repo.Save(name, email); err != nil {
        return fmt.Errorf("save: %w", err)
    }
    return s.notifier.SendWelcome(email)
}
```

The service function reads like a recipe. Each piece can be tested with a mock or stub.
Changing the notification channel doesn't touch the persistence layer.

---

## 2. Dependency Inversion — Program to Interfaces

**The idea:** High-level policy should not depend on low-level detail. Both should depend
on abstractions. In practice: accept interfaces, return structs.

**Why this makes modules deeper:** The interface *is* the simple surface. The implementation
behind it can be arbitrarily complex — retry logic, connection pooling, caching — and none
of that leaks to callers.

**When it helps:** Anywhere you have an external dependency (database, API client, payment
processor, message queue) or anywhere you want to test behavior in isolation.

**When to ease up:** Don't create interfaces for things with exactly one implementation that
are unlikely to ever change. An interface for your `utils.FormatDate()` function is ceremony,
not design. Let the need for a second implementation or a test double drive interface creation.

### Example (Go)

**Before — concrete dependency baked in:**

```go
type OrderService struct{}

func (s *OrderService) Checkout(orderID string) error {
    client := &StripeClient{APIKey: os.Getenv("STRIPE_KEY")}
    return client.Charge(orderID)
}
```

Can't test without hitting Stripe. Can't swap providers without rewriting Checkout.

**After — depend on a contract, not a vendor:**

```go
type PaymentProcessor interface {
    Charge(orderID string) error
}

type OrderService struct {
    payments PaymentProcessor
}

func (s *OrderService) Checkout(orderID string) error {
    return s.payments.Charge(orderID)
}
```

Tests inject a fake. Swapping Stripe for Square is a wiring change at the composition root.
The OrderService doesn't know or care what's behind the interface — the module got deeper.

---

## 3. DRY with Judgment

**The idea:** When the same logic appears in multiple places, a change to that logic requires
finding and updating every copy (shotgun surgery). Extracting it into one place means one
change, one place.

**The trap:** Two pieces of code that *look* similar but serve different purposes. If you
merge them, you create coupling between unrelated concerns. When one use case evolves, the
shared abstraction gets littered with conditionals to handle diverging requirements.

**Rule of thumb:** Duplication is cheaper than the wrong abstraction. Wait until you've seen
a pattern three times before extracting, so you know what the real common shape is.

### Example (Go)

**Before — retry logic copy-pasted into every API call:**

```go
func FetchUser(id string) (*http.Response, error) {
    var resp *http.Response
    var err error
    for i := 0; i < 3; i++ {
        resp, err = http.Get(apiURL + "/users/" + id)
        if err == nil && resp.StatusCode == 200 {
            break
        }
        time.Sleep(time.Duration(i+1) * time.Second)
    }
    return resp, err
}

func FetchOrder(id string) (*http.Response, error) {
    var resp *http.Response
    var err error
    for i := 0; i < 3; i++ {
        resp, err = http.Get(apiURL + "/orders/" + id)
        if err == nil && resp.StatusCode == 200 {
            break
        }
        time.Sleep(time.Duration(i+1) * time.Second)
    }
    return resp, err
}
```

**After — the retry policy lives in one place:**

```go
func withRetry(attempts int, fn func() (*http.Response, error)) (*http.Response, error) {
    var resp *http.Response
    var err error
    for i := 0; i < attempts; i++ {
        resp, err = fn()
        if err == nil && resp.StatusCode == 200 {
            return resp, nil
        }
        time.Sleep(time.Duration(i+1) * time.Second)
    }
    return resp, fmt.Errorf("failed after %d attempts: %w", attempts, err)
}

func FetchUser(id string) (*http.Response, error) {
    return withRetry(3, func() (*http.Response, error) {
        return http.Get(apiURL + "/users/" + id)
    })
}
```

One place to add jitter, change backoff strategy, or add logging. The retry policy is
a deep module in miniature — simple interface, nontrivial behavior inside.

---

## 4. Least Surprise — Clear Control Flow

**The idea:** Code should do what a reader expects from its name, signature, and position.
Clever code that saves a few lines but requires careful study to understand is a net negative.

**Deep module connection:** A function's *interface* includes its name and the expectations
that name creates. If the behavior is surprising, the interface is leaking — callers have
to read the implementation to use it correctly.

**When it helps:** Always. This is the least controversial principle.

**When to ease up:** Performance-critical inner loops where an unobvious optimization has
a measurable impact. In that case, comment heavily to explain *why* the code looks unusual.

### Example (Python)

**Before — dense, nested, hard to debug:**

```python
def process(items):
    return [
        (lambda x: x["name"].upper() if x.get("active") else None)(
            {**item, "score": item["score"] * (2 if item["vip"] else 1)}
        )
        for item in items
        if item["score"] > 0
    ]
```

**After — explicit steps, each with a name and a purpose:**

```python
def process(items):
    results = []
    for item in items:
        if item["score"] <= 0:
            continue

        adjusted_score = item["score"] * 2 if item["vip"] else item["score"]
        enriched = {**item, "score": adjusted_score}

        if enriched.get("active"):
            results.append(enriched["name"].upper())

    return results
```

Same output. But now you can set a breakpoint on any step, and each transformation
has a name that explains what it's doing.

---

## 5. Open/Closed — Extend Without Modifying

**The idea:** You should be able to add new behavior (a new export format, a new payment
method, a new notification channel) without modifying existing, tested code.

**Deep module connection:** This is what makes interfaces powerful at the system level.
Each implementation is a deep module — new capabilities plug in without touching the wiring.

**When it helps:** When you have a clear axis of variation — export formats, storage
backends, auth providers. The switch statement that keeps growing is the smell.

**When to ease up:** If you have two formats and will never have three, a simple `if/else`
is clearer than an interface hierarchy. The point of OCP is to handle *actual* variation,
not hypothetical future variation.

### Example (Go)

**Before — every new format means editing one growing function:**

```go
func Export(data []Record, format string) ([]byte, error) {
    switch format {
    case "json":
        return json.Marshal(data)
    case "csv":
        // 30 lines of csv logic...
    case "xml":
        // 30 lines of xml logic...
    default:
        return nil, fmt.Errorf("unsupported: %s", format)
    }
}
```

**After — new formats are new types, existing code untouched:**

```go
type Exporter interface {
    Export(data []Record) ([]byte, error)
}

type JSONExporter struct{}
func (e *JSONExporter) Export(data []Record) ([]byte, error) {
    return json.Marshal(data)
}

type CSVExporter struct{}
func (e *CSVExporter) Export(data []Record) ([]byte, error) {
    // csv-specific logic, self-contained
}

// Adding Parquet? New struct, new file. Nothing else changes.
```

---

## 6. Error Handling as Design

**The idea:** Errors are part of your module's interface. How a function fails is as
important as how it succeeds. Sloppy error handling — swallowing errors, returning bare
strings, using panics for control flow — makes modules shallow because callers can't
reason about failure modes from the interface alone.

**Deep module connection:** A well-designed error strategy hides recovery details inside
the module and presents callers with clear, actionable error information. The caller
knows *what* went wrong and *whether to retry*, without knowing *how* the module works
internally.

**When it helps:** Any boundary — between services, between layers, at API surfaces.

**When to ease up:** Quick scripts, prototypes, and spike code. Use `log.Fatal` and
move on. Just don't let that style leak into production code.

### Example (Go)

**Before — errors swallowed or leaked without context:**

```go
func LoadConfig(path string) (*Config, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, err  // caller sees "no such file" with no context
    }
    var cfg Config
    json.Unmarshal(data, &cfg)  // error silently ignored
    return &cfg, nil
}
```

**After — errors wrapped with context, nothing silently dropped:**

```go
func LoadConfig(path string) (*Config, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, fmt.Errorf("reading config %s: %w", path, err)
    }
    var cfg Config
    if err := json.Unmarshal(data, &cfg); err != nil {
        return nil, fmt.Errorf("parsing config %s: %w", path, err)
    }
    return &cfg, nil
}
```

Now callers can distinguish "file not found" from "malformed JSON" without opening this
function. The error messages form a stack trace of intent — each layer adds *why* it
was doing the operation that failed.

### Sentinel errors and typed errors

For errors that callers need to handle programmatically, use sentinel values or typed errors
rather than string matching:

```go
var ErrNotFound = errors.New("not found")
var ErrConflict = errors.New("conflict")

func (r *UserRepo) Find(id string) (*User, error) {
    row := r.db.QueryRow("SELECT ... WHERE id = $1", id)
    var u User
    if err := row.Scan(&u.Name, &u.Email); err != nil {
        if errors.Is(err, sql.ErrNoRows) {
            return nil, fmt.Errorf("user %s: %w", id, ErrNotFound)
        }
        return nil, fmt.Errorf("querying user %s: %w", id, err)
    }
    return &u, nil
}
```

Callers use `errors.Is(err, ErrNotFound)` — they don't need to know this module uses SQL.
The database is an implementation detail that stays hidden.
