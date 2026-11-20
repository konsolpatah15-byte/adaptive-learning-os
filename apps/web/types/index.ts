export interface Competency {
  code: string; name: string; name_id?: string;
  mastery: number; confidence: number; status: string;
  last_practiced_at?: string;
}

export interface Subject {
  code: string; name: string; name_id: string;
  description: string; competencies: Competency[];
}

export interface StudySchedule {
  id: number; plan_date: string; start_time: string;
  minutes: number; track: string; activity: string;
  title: string; status: string; manual_override: boolean;
  competency_id?: number;
}

export interface LearningSession {
  id: number; track: string; mode: string;
  duration_minutes: number; summary?: string;
  learner_feedback?: string; started_at: string;
}

export interface Goal {
  id: number; track: string; title: string;
  target_date?: string; status: string;
}

export interface ReviewQueue {
  id: number; competency_id: number;
  due_at: string; interval_days: number;
  repetitions: number; status: string;
}

export interface MistakeEntry {
  id: number; question: string;
  learner_answer?: string; correct_answer?: string;
  root_cause: string; explanation?: string;
  resolved: boolean; created_at: string;
}

export interface DashboardData {
  goals: Goal[];
  today_plan: StudySchedule[];
  recent_sessions: LearningSession[];
  weakest_competencies: Competency[];
  upcoming_reviews: ReviewQueue[];
}