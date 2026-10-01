from contextlib import asynccontextmanager

from fastapi import FastAPI

from . import models  # noqa: F401  (registers tables on Base)
from .database import Base, engine
from .routers import calories_in, calories_out, summary, users, weight


@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(engine)  # creates tables if they don't exist
    yield


app = FastAPI(title="Fitness Tracker API", version="0.1.0", lifespan=lifespan)

for r in (users, calories_in, calories_out, weight, summary):
    app.include_router(r.router)


@app.get("/health", tags=["meta"])
def health():
    return {"status": "ok"}
