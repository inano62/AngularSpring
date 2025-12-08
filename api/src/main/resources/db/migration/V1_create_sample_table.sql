-- V1__initial_schema.sql
-- PLASMIC カルテ用 初期スキーマ

-- タイムゾーン付きの作成・更新日時を共通で使う想定

-- 患者テーブル
CREATE TABLE patients (
    id              BIGSERIAL PRIMARY KEY,
    patient_code    VARCHAR(50) UNIQUE NOT NULL,      -- 院内ID／カルテ番号
    full_name       VARCHAR(100) NOT NULL,
    full_name_kana  VARCHAR(100),
    date_of_birth   DATE,
    sex             VARCHAR(10),                      -- 後で enum / マスタに切り出してOK
    phone_number    VARCHAR(20),
    email           VARCHAR(255),
    address         TEXT,
    note            TEXT,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Noteテーブル
CREATE TABLE note (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    content TEXT
);

-- 医師テーブル
CREATE TABLE doctors (
    id              BIGSERIAL PRIMARY KEY,
    doctor_code     VARCHAR(50) UNIQUE NOT NULL,      -- 社員番号・医師コードなど
    full_name       VARCHAR(100) NOT NULL,
    department      VARCHAR(100),
    email           VARCHAR(255),
    phone_number    VARCHAR(20),

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ユーザー（ログインアカウント）テーブル
-- 最初は超シンプルにしておいて、権限まわりは後続のマイグレーションで拡張
CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    username        VARCHAR(50) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    display_name    VARCHAR(100),

    role            VARCHAR(50) NOT NULL DEFAULT 'USER',  -- ADMIN / DOCTOR / NURSE など想定

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    active          BOOLEAN NOT NULL DEFAULT TRUE
);

-- 診療記録（カルテ本体）
CREATE TABLE medical_records (
    id              BIGSERIAL PRIMARY KEY,
    patient_id      BIGINT NOT NULL,
    doctor_id       BIGINT,
    visit_date      TIMESTAMPTZ NOT NULL DEFAULT NOW(),   -- 受診日時
    title           VARCHAR(255),
    content         TEXT NOT NULL,                        -- SOAP など本文

    status          VARCHAR(50) NOT NULL DEFAULT 'OPEN',  -- OPEN / CLOSED など
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_medical_records_patient
        FOREIGN KEY (patient_id) REFERENCES patients (id),

    CONSTRAINT fk_medical_records_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctors (id)
);

-- 予約テーブル（とりあえず最低限）
CREATE TABLE appointments (
    id              BIGSERIAL PRIMARY KEY,
    patient_id      BIGINT NOT NULL,
    doctor_id       BIGINT,
    reserved_at     TIMESTAMPTZ NOT NULL,      -- 予約日時
    status          VARCHAR(50) NOT NULL DEFAULT 'RESERVED', -- RESERVED / CANCELLED / DONE 等

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id) REFERENCES patients (id),

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctors (id)
);

-- インデックス（検索でよく使いそうなものだけ最初に貼っておく）
CREATE INDEX idx_patients_patient_code ON patients(patient_code);
CREATE INDEX idx_patients_full_name ON patients(full_name);

CREATE INDEX idx_doctors_doctor_code ON doctors(doctor_code);

CREATE INDEX idx_medical_records_patient_id ON medical_records(patient_id);
CREATE INDEX idx_medical_records_visit_date ON medical_records(visit_date);

CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_reserved_at ON appointments(reserved_at);