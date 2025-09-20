# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Plato.Repo.insert!(%Plato.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create a sample campus
{:ok, campus} =
  Plato.Domain.create_campus(%{
    name: "플라토 학원",
    address: "서울시 강남구 테헤란로 123",
    phone: "02-1234-5678",
    email: "info@plato-academy.com"
  })

# Create sample students
{:ok, _student1} =
  Plato.Domain.create_student(%{
    name: "김철수",
    phone: "010-1234-5678",
    grade: 9,
    campus_id: campus.id
  })

{:ok, _student2} =
  Plato.Domain.create_student(%{
    name: "이영희",
    phone: "010-9876-5432",
    grade: 10,
    campus_id: campus.id
  })

# Create sample instructor
{:ok, _instructor} =
  Plato.Domain.create_instructor(%{
    name: "박선생",
    email: "teacher@plato-academy.com",
    phone: "010-1111-2222",
    campus_id: campus.id
  })

# Create sample problems
{:ok, _problem1} =
  Plato.Domain.create_problem(%{
    content: "다음 방정식을 풀어보세요: 2x + 5 = 11",
    subject: :math,
    difficulty: :medium,
    option_a: "x = 2",
    option_b: "x = 3",
    option_c: "x = 4",
    option_d: "x = 5",
    correct_answer: :b,
    explanation: "2x + 5 = 11에서 2x = 6이므로 x = 3입니다.",
    campus_id: campus.id
  })

{:ok, _problem2} =
  Plato.Domain.create_problem(%{
    content: "다음 중 올바른 영어 문장은?",
    subject: :english,
    difficulty: :low,
    option_a: "I am go to school",
    option_b: "I go to school",
    option_c: "I goes to school",
    option_d: "I going to school",
    correct_answer: :b,
    explanation: "주어가 I일 때는 동사 원형을 사용합니다.",
    campus_id: campus.id
  })

IO.puts("시드 데이터 생성 완료!")
