from faker import Faker
import pandas as pd
import random
import math
from datetime import date, timedelta


NUMBER_OF_SUBJECTS = 3
NUMBER_OF_STUDENTS = 10
NUMBER_OF_YEARS = 1
START_DATE_YEAR = 2025 - NUMBER_OF_YEARS + 1


def calculate_age(pesel):
    birth_year = pesel[0:2]

    if birth_year[0] == "0":
        birth_year = 2025 - int(birth_year)
    else:
        birth_year = 2025 - (int(birth_year) + 1900)

    return birth_year


def random_grade():
    grades = [1,2,3,4,5,6]
    probability = [0.1, 0.1, 0.3, 0.3, 0.15, 0.05]
    x = random.random()
    sum = 0

    for p in range(len(probability)):
        sum += probability[p]
        if x <= sum:
            x = p
            break

    return grades[x]


def random_attendance():
    freq = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
    probability = [0.01, 0.02, 0.04, 0.03, 0.05, 0.05, 0.3, 0.3, 0.15, 0.05]
    x = random.random()
    sum = 0

    for p in range(len(probability)):
        sum += probability[p]
        if x <= sum:
            x = p
            break
    if freq[x] == 1:
        return 100
    else:
        value = random.uniform(freq[x], freq[x]+0.1) * 100
        return min(int(value), 100)


def random_is_current():
    x = random.random()

    if x <= 0.05:
        return 0
    return 1


def set_id_exam(id_exam_date, this_class, iterator):
    if this_class[0] != "4":
        return None
    if random_is_current() == 0:
        return None

    return id_exam_date + iterator


def set_exam_result(id_exam_date):
    if id_exam_date is None:
        return None

    return random_attendance()


def set_junk_attendance(attendance):
    if attendance < 50:
        return "0-49"
    elif attendance < 70:
        return "50-69"
    elif attendance < 90:
        return "70-89"
    else:
        return "90-100"


def set_id_junk(junk, grade, attendance, result, id_exam_date):
    subject_passed = 1
    exam_passed = 1
    cat_attendance = set_junk_attendance(attendance)

    if grade == 1 or cat_attendance == "0-49":
        subject_passed = 0
    if result is None or id_exam_date is None:
        exam_passed = None
    elif result < 30 and id_exam_date is not None:
        exam_passed = 0

    for i,j in enumerate(junk):
        if j["Ocena"] == grade and j["Frekwencja"] == cat_attendance \
                and j["Czy_zdany_przedmiot"] == subject_passed and j["Czy_zdana_matura"] == exam_passed:
            return i+1

    return None


def calculate_class_size(end_year, classes):
    for element in end_year[0::NUMBER_OF_SUBJECTS]:
        classes[element["ID_Klasy"]-1]["Wielkosc_klasy"] += 1

    for c in classes:
        if c["Wielkosc_klasy"] < 10:
            c["Wielkosc_klasy"] = "mala"
        elif c["Wielkosc_klasy"] < 20:
            c["Wielkosc_klasy"] = "srednia"
        else:
            c["Wielkosc_klasy"] = "duza"

    return classes


def filter_students(student_in_class, class_number):
    filtered_students = []
    for i in range(len(student_in_class)):
        if int(student_in_class[i]["IDKlasy"][0]) == class_number:
            filtered_students.append(student_in_class[i])

    return filtered_students


def generate_students(length, faker):
    students = []
    for i in range(length):
        full_name = faker.first_name() + " " + faker.last_name()
        pesel = faker.pesel()

        students.append({
            "Pesel": pesel,
            "ImieNazwisko": full_name,
            "Wiek": calculate_age(pesel),
            "IsCurrent": 1
        })
    return students


def generate_classes():
    classes = []
    number = [3, 4]
    letter = ['A', 'B']
    for i in number:
        for j in letter:
            classes.append({
                "Nazwa": f'{i}{j}',
                "Wielkosc_klasy": 0
            })
    return classes


def generate_subjects():
    subjects = []
    names = ["Jezyk polski", "Jezyk angielski", "Matematyka"]
    for name in names:
        subjects.append({
            "Nazwa": name
        })

    return subjects


def generate_date():
    start = date(START_DATE_YEAR, 1, 1)
    end = date(START_DATE_YEAR + NUMBER_OF_YEARS - 1, 12, 31)
    current_date = start
    all_dates = []

    while current_date < end:
        all_dates.append({
            "Data": current_date.isoformat(),
            "Rok": current_date.year,
            "Miesiac": current_date.month,
            "Dzien": current_date.day
        })
        current_date += timedelta(days=1)

    return all_dates


def generate_junk():
    grades = [1,2,3,4,5,6]
    attendances = ["0-49", "50-69", "70-89", "90-100"]
    passed_exams = [None, 0, 1]
    junk = []

    for grade in grades:
        for att in attendances:
                for exam in passed_exams:
                    subject = 1
                    if grade == 1 or att == "0-49":
                        subject = 0

                    junk.append({
                        "Ocena": grade,
                        "Frekwencja": att,
                        "Czy_zdany_przedmiot": subject,
                        "Czy_zdana_matura": exam
                    })

    return junk


def generate_end_year(students, classes, len_subjects, id_school_year, id_exam_date, junk):
    end_year = []

    for i in range(len(students)):
        for j in range(len_subjects):
            this_class = random.choice([_ for _ in range(len(classes))])
            new_id_exam_date = set_id_exam(id_exam_date, classes[this_class]['Nazwa'], j)
            grade = random_grade()
            attendance = random_attendance()
            exam_result = set_exam_result(new_id_exam_date)

            end_year.append({
                "ID_Ucznia": i+1,
                "ID_Klasy": this_class+1,
                "ID_Przedmiotu": j+1,
                "ID_Roku_szkolnego": id_school_year,
                "ID_Daty_matury": new_id_exam_date,
                "ID_Junk": set_id_junk(junk, grade, attendance, exam_result, new_id_exam_date),
                "Ocena_z_przedmiotu": grade,
                "Frekwencja": attendance,
                "Wynik_z_matury": exam_result,
            })

    return end_year


faker = Faker("pl_PL")
students = generate_students(NUMBER_OF_STUDENTS, faker)
classes = generate_classes()
subjects = generate_subjects()
junk = generate_junk()
school_year = generate_date()
exam_date = generate_date()
end_year = generate_end_year(students, classes, len(subjects), 150, 100, junk)
classes = calculate_class_size(end_year, classes)

print(students)
print(classes)
print(subjects)
print(junk)
print(school_year)
print(exam_date)
print(end_year)

df1 = pd.DataFrame(students, columns=["Pesel", "ImieNazwisko", "Wiek", "IsCurrent"])
df2 = pd.DataFrame(classes, columns=["Nazwa", "Wielkosc_klasy"])
df3 = pd.DataFrame(subjects, columns=["Nazwa"])
df4 = pd.DataFrame(junk, columns=["Ocena", "Frekwencja", "Czy_zdany_przedmiot", "Czy_zdana_matura"])
df5 = pd.DataFrame(end_year, columns=["ID_Ucznia", "ID_Klasy","ID_Przedmiotu", "ID_Roku_szkolnego", "ID_Daty_matury",
                                      "ID_Junk", "Ocena_z_przedmiotu", "Frekwencja", "Wynik_z_matury"])
df6 = pd.DataFrame(school_year, columns=["Data", "Rok", "Miesiac", "Dzien"])
df7 = pd.DataFrame(exam_date, columns=["Data", "Rok", "Miesiac", "Dzien"])

df1.to_csv("dane/Uczen.csv", index=False)
df2.to_csv("dane/Klasa.csv", index=False)
df3.to_csv("dane/Przedmiot.csv", index=False)
df4.to_csv("dane/Junk.csv", index=False)
df5.to_csv("dane/Koniec_roku.csv", index=False)
df6.to_csv("dane/Data_rok_szkolny.csv", index=False)
df7.to_csv("dane/Data_matury.csv", index=False)

