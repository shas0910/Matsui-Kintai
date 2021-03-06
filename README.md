# テーブル設計

## users テーブル

| Column             | Type    | Options                  |
| ------------------ | ------- | ------------------------ |
| email              | string  | null: false unique: true |
| encrypted_password | string  | null: false              |
| last_name          | string  | null: false              |
| first_name         | string  | null: false              |
| last_name_kana     | string  | null: false              |
| first_name_kana    | string  | null: false              |
| department         | string  | null: false              |
| user_type          | string  | null: false              |
| hire_date          | string  | null: false              |
| approver_id        | integer |                          |

### Association

- has_many :timecards
- has_many :schedule
- has_many :travel_costs

## year_months テーブル

| Column     | Type    | Options     |
| ---------- | ------- | ----------- |
| year       | integer | null: false |
| month      | integer | null: false |
| first_date | date    | null: false |
| last_date  | date    | null: false |

### Association

- has_many :days

## days テーブル

| Column   | Type      | Options     |
| -------- | --------- | ----------- |
| month    | reference | null: false |
| date     | date      | null: false |
| day_type | string    | null: false |

### Association

- belongs_to :month
- has_many :timecards
- has_many :schedules

## timecards テーブル

| Column       | Type      | Options     |
| ------------ | --------- | ----------- |
| user         | reference | null: false |
| day          | reference | null: false |
| start        | time      |             |
| finish       | time      |             |
| break_start  | time      |             |
| break_finish | time      |             |

### Association

- belongs_to :user
- belongs_to :day
- has_many :pending_timecards

## pending_times テーブル

| Column             | Type      | Options     |
| ------------------ | --------- | ----------- |
| timecard           | reference | null: false |
| start              | time      |             |
| finish             | time      |             |
| break_start        | time      |             |
| break_finish       | time      |             |
| status             | string    | null: false |
| comment_request    | text      |             |
| comment_permission | text      |             |

### Association

- belongs_to :timecard

## schedules テーブル

| Column   | Type      | Options                        |
| -------- | --------- | ------------------------------ |
| user     | reference | null: false, foreign_key: true |
| day      | reference | null: false, foreign_key: true |
| schedule | string    |                                |
| remark   | text      |                                |

### Association

- belongs_to :user
- belongs_to :day
- has_many :pending_schedules

## pending_schedules テーブル

| Column             | Type      | Options                        |
| ------------------ | --------- | ------------------------------ |
| schedule           | reference | null: false, foreign_key: true |
| schedule           | string    | null: false                    |
| remark             | text      |                                |
| status             | string    | null: false                    |
| comment_request    | text      |                                |
| comment_permission | text      |                                |

### Association

- belongs_to :schedule

## Travel_cost テーブル

| Column      | Type      | Options     |
| ----------- | --------- | ----------- |
| user        | reference | null: false |
| travel_cost | integer   | null: false |
| comment     | text      | null: false |

### Association

- belongs_to :user