# Fitness Tracker API (FastAPI + MySQL)

Skeleton backend for logging **calorie intake**, **calorie outtake (burn)**, and **weight**.

## Structure
```
fitness_tracker/
├── app/
│   ├── main.py            # FastAPI app, router wiring, table creation on startup
│   ├── database.py        # SQLAlchemy engine/session (MySQL via PyMySQL)
│   ├── models.py          # ORM tables
│   ├── schemas.py         # Pydantic request/response models + validation
│   ├── deps.py            # shared dependency: load user or 404
│   └── routers/
│       ├── users.py
│       ├── calories_in.py   # intake
│       ├── calories_out.py  # outtake
│       ├── weight.py
│       └── summary.py       # daily in / out / net + latest weight
├── sql/schema.sql         # MySQL DDL (auto-loaded by docker-compose)
├── docker-compose.yml     # MySQL 8.4
├── requirements.txt
└── .env.example
```

## Run
```bash
docker compose up -d                 # start MySQL
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
export DATABASE_URL=mysql+pymysql://fitness:fitness@localhost:3306/fitness_db
uvicorn app.main:app --reload
```
Interactive docs: http://localhost:8000/docs

## API
| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/users` | Create user |
| GET | `/users/{id}` | Get user |
| POST | `/users/{id}/calories/intake` | Log food eaten |
| GET | `/users/{id}/calories/intake?from_date=&to_date=` | List intake |
| DELETE | `/users/{id}/calories/intake/{entry_id}` | Delete entry |
| POST | `/users/{id}/calories/outtake` | Log calories burned |
| GET | `/users/{id}/calories/outtake?from_date=&to_date=` | List burn |
| DELETE | `/users/{id}/calories/outtake/{entry_id}` | Delete entry |
| POST | `/users/{id}/weight` | Log weight (kg) |
| GET | `/users/{id}/weight?from_date=&to_date=` | Weight history |
| GET | `/users/{id}/weight/latest` | Most recent weight |
| DELETE | `/users/{id}/weight/{entry_id}` | Delete entry |
| GET | `/users/{id}/summary?on=YYYY-MM-DD` | Daily in / out / net + weight |

## Example calls
```bash
curl -X POST localhost:8000/users -H 'Content-Type: application/json' \
  -d '{"name":"Asha","email":"asha@example.com","height_cm":165}'

curl -X POST localhost:8000/users/1/calories/intake -H 'Content-Type: application/json' \
  -d '{"food_name":"Poha","meal_type":"breakfast","calories":250,"carbs_g":45}'

curl -X POST localhost:8000/users/1/calories/outtake -H 'Content-Type: application/json' \
  -d '{"activity":"Running","duration_min":30,"calories_burned":300}'

curl -X POST localhost:8000/users/1/weight -H 'Content-Type: application/json' \
  -d '{"weight_kg":62.4}'

curl localhost:8000/users/1/summary
```

## Next steps (not included in the skeleton)
Authentication (JWT) instead of `user_id` in the path, Alembic migrations, goals/targets,
a food catalog table, and tests.
