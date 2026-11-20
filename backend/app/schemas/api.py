"""Pydantic schemas — every API input validated here."""
from __future__ import annotations
from pydantic import BaseModel, Field, field_validator


class LoginIn(BaseModel):
    username: str = Field(min_length=2, max_length=64)
    password: str = Field(min_length=6, max_length=128)


class ChatIn(BaseModel):
    message: str = Field(min_length=1, max_length=4000)
    mode: str = "explanation"

    @field_validator("mode")
    @classmethod
    def mode_ok(cls, v):
        allowed = {"explanation", "guided_practice", "discussion", "simulation", "review"}
        if v not in allowed:
            raise ValueError(f"mode must be one of {sorted(allowed)}")
        return v


class FeedbackIn(BaseModel):
    session_id: int | None = None
    feedback: str = Field(min_length=1, max_length=500)


class SessionIn(BaseModel):
    track: str
    mode: str = "explanation"
    competency_code: str | None = None

    @field_validator("track")
    @classmethod
    def track_ok(cls, v):
        if v not in {"ielts", "snbt", "mixed"}:
            raise ValueError("track must be ielts|snbt|mixed")
        return v


class SessionEndIn(BaseModel):
    summary: str = Field(default="", max_length=2000)
    feedback: str | None = Field(default=None, max_length=500)


class ObservationIn(BaseModel):
    competency_code: str = Field(min_length=3, max_length=80)
    correct: bool
    difficulty: int = Field(default=2, ge=1, le=5)
    independent: bool = True
    kind: str = "light_check"
    confidence_self: float | None = Field(default=None, ge=0, le=100)
    question: str = Field(default="", max_length=2000)
    learner_answer: str = Field(default="", max_length=2000)
    correct_answer: str = Field(default="", max_length=2000)
    diagnosis_hints: dict | None = None

    @field_validator("kind")
    @classmethod
    def kind_ok(cls, v):
        if v not in {"light_check", "practice", "formal", "review"}:
            raise ValueError("invalid kind")
        return v


class CompetencyPatch(BaseModel):
    name_id: str | None = Field(default=None, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    difficulty: int | None = Field(default=None, ge=1, le=5)
    next_review_at: str | None = None


class MistakeIn(BaseModel):
    competency_code: str | None = None
    track: str
    question: str = Field(min_length=1, max_length=2000)
    learner_answer: str = Field(default="", max_length=2000)
    correct_answer: str = Field(default="", max_length=2000)
    root_cause: str = "unknown"
    explanation: str = Field(default="", max_length=4000)

    @field_validator("root_cause")
    @classmethod
    def cause_ok(cls, v):
        allowed = {"conceptual", "calculation", "misreading", "vocabulary", "grammar",
                   "logical_reasoning", "careless", "time_management",
                   "background_knowledge", "unknown"}
        if v not in allowed:
            raise ValueError("invalid root_cause")
        return v


class MistakePatch(BaseModel):
    resolved: bool | None = None
    explanation: str | None = Field(default=None, max_length=4000)
    root_cause: str | None = None


class ScheduleIn(BaseModel):
    plan_date: str = Field(pattern=r"^\d{4}-\d{2}-\d{2}$")
    start_time: str = Field(pattern=r"^\d{2}:\d{2}$")
    minutes: int = Field(ge=5, le=240)
    track: str
    activity: str = "explanation"
    competency_code: str | None = None
    title: str = Field(min_length=1, max_length=200)


class SchedulePatch(BaseModel):
    status: str | None = None
    start_time: str | None = Field(default=None, pattern=r"^\d{2}:\d{2}$")
    minutes: int | None = Field(default=None, ge=5, le=240)
    title: str | None = Field(default=None, max_length=200)

    @field_validator("status")
    @classmethod
    def status_ok(cls, v):
        if v is not None and v not in {"planned", "done", "skipped", "moved"}:
            raise ValueError("invalid status")
        return v


class PreferencesIn(BaseModel):
    explanation_language: str = "id"
    weekday_minutes: int = Field(default=90, ge=15, le=480)
    weekend_minutes: int = Field(default=210, ge=30, le=600)
    weekday_window: list[str] = ["16:30", "19:00"]
    teach_before_test: bool = True
    allow_less_practice: bool = True
    active_snbt_subtest: str = "pu"
    ielts_target_date: str | None = None
    autonomy_level: str = "guided"

    @field_validator("active_snbt_subtest")
    @classmethod
    def subtest_ok(cls, v):
        if v not in {"pu", "ppu", "pbm", "pk", "lbi", "lbe", "pm"}:
            raise ValueError("invalid subtest")
        return v