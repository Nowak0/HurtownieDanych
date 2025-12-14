from faker import Faker
import pandas as pd
import random

NUMBER_OF_SUBJECTS = 3
NUMBER_OF_STUDENTS = 25000
START_DATE_SCHOOL = "2024-09-01"
START_DATE_EXAM = "2025-05-01"
NUMBER_OF_YEARS = 3
GRADES = [1,2,3,4,5,6]
GRADE_PROBABILITY = [0.1, 0.1, 0.3, 0.3, 0.15, 0.05]
FREQ = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
FREQ_PROBABILITY = [0.01, 0.02, 0.04, 0.03, 0.05, 0.05, 0.3, 0.3, 0.15, 0.05]


def random_grade():
    x = random.random()
    sum = 0

    for p in range(len(GRADE_PROBABILITY)):
        sum += GRADE_PROBABILITY[p]
        if x <= sum:
            x = p
            break

    return GRADES[x]


def random_frequency():
    x = random.random()
    sum = 0

    for p in range(len(FREQ_PROBABILITY)):
        sum += FREQ_PROBABILITY[p]
        if x <= sum:
            x = p
            break

    if FREQ[x] == 1:
        return 100
    else:
        value = random.uniform(FREQ[x], FREQ[x] + 0.1) * 100
        return int(value)


def filter_students(student_in_class, class_number):
    filtered_students = [s for s in student_in_class if int(s["Nazwa_klasy"][0]) == int(class_number)]
    return filtered_students


def check_pid(pesel):
    if len(pesel) != 11:
        return False
    if int(pesel[2:4]) > 12:
        return False
    if int(pesel[0:2]) < 90:
        return False

    return True


def assign_class_to_student(pid, old_student_map, class_names, empty_old_student_in_class, class_year_1):
    if pid in old_student_map:
        prev_class = old_student_map[pid]
        this_class = str(int(prev_class[0]) + 1) + prev_class[1]
        if this_class not in class_names:
            return None
    elif empty_old_student_in_class:
        this_class = random.choice(class_names)
    else:
        this_class = random.choice(class_year_1)

    return this_class


def generate_students(length, faker, students = None):
    if students is None:
        students = []

    for i in range(length):
        pesel = str(faker.pesel())
        while not check_pid(pesel):
            pesel = str(faker.pesel())

        students.append({
            "Pesel": pesel,
            "Imie": faker.first_name(),
            "Nazwisko": faker.last_name(),
        })
    return students


def generate_classes(year):
    classes = []
    number = [1, 2, 3, 4]
    letter = ['A', 'B', 'C', 'D']
    for i in number:
        for j in letter:
            classes.append({
                "Nazwa_klasy": f'{i}{j}',
                "Rok_szkolny": year
            })
    return classes


def generate_subjects():
    subjects = []
    names = ["Jezyk polski", "Jezyk angielski", "Matematyka"]
    i = 1
    for name in names:
        subjects.append({
            "ID_Przedmiotu": i,
            "Nazwa": name
        })
        i+=1

    return subjects


def generate_end_year(student_in_class):
    end_year = []

    for i in range(len(student_in_class)):
        for j in range(NUMBER_OF_SUBJECTS):
            end_year.append({
                "ID_Ucznia_w_klasie": student_in_class[i]["ID_Ucznia_w_klasie"],
                "ID_Przedmiotu": j+1,
                "Ocena": random_grade(),
                "Frekwencja": random_frequency()
            })
    return end_year


def generate_student_in_class(students, classes, student_in_class_id, old_student_in_class = None):
    if old_student_in_class is None:
        old_student_in_class = []
    new_student_in_class = []
    pids_to_remove = []
    class_names = [c["Nazwa_klasy"] for c in classes]
    class_year_1 = [c for c in class_names if c[0] == "1"]
    empty_old_student_in_class = True if len(old_student_in_class) == 0 else False
    old_student_map = {}

    if not empty_old_student_in_class:
        old_student_map = {s["Pesel"]: s["Nazwa_klasy"] for s in old_student_in_class}

    for i in range(len(students)):
        pid = students[i]['Pesel']

        this_class = assign_class_to_student(pid, old_student_map, class_names, empty_old_student_in_class, class_year_1)
        if this_class is None:
            pids_to_remove.append(pid)
            continue

        student_in_class_id += 1
        new_student_in_class.append({
            "ID_Ucznia_w_klasie": student_in_class_id,
            "Pesel": pid,
            "Nazwa_klasy": this_class
        })

    students = [s for s in students if s["Pesel"] not in pids_to_remove]

    return new_student_in_class, students, student_in_class_id


def generate_results(student_in_class, subjects, exam_date):
    results = []
    exam_students = filter_students(student_in_class, 4)
    len_exam_students = len(exam_students)
    attended = len_exam_students
    if len_exam_students > 6:
        attended = int(len_exam_students - 0.1*len_exam_students)

    for i in range(attended):
        for j in range(NUMBER_OF_SUBJECTS):
            s = exam_date.split("-")
            new_date = s[0] + "-" + s[1] + "-" + str(int(s[2])+j)

            results.append({
                "Pesel": exam_students[i]["Pesel"],
                "Przedmiot": subjects[j]['Nazwa'],
                "Wynik": random_frequency(),
                "Data_matury": new_date
            })

    return results


def adjust_year(date, i):
    date_parts = date.split("-")
    new_date = str(int(date_parts[0])+i) + "-" + str(date_parts[1]) + "-" + str(date_parts[2])
    return new_date


faker = Faker("pl_PL")
students = []
student_in_class_id = 0
student_in_class = []

for i in range(NUMBER_OF_YEARS):
    print(f"\nProcessing year {i+1}/{NUMBER_OF_YEARS}...")

    print("\tGenerating students")
    if i == 0:
        students = generate_students(NUMBER_OF_STUDENTS, faker, students)
    else:
        students = generate_students(NUMBER_OF_STUDENTS // 4, faker, students)

    print("\tGenerating classes")
    classes = generate_classes(adjust_year(START_DATE_SCHOOL, i))

    print("\tGenerating subjects")
    subjects = generate_subjects()

    print("\tGenerating students in classes")
    student_in_class, students, student_in_class_id = generate_student_in_class(students, classes, student_in_class_id, student_in_class)

    print("\tGenerating end year results")
    end_year = generate_end_year(student_in_class)
    results = generate_results(student_in_class, subjects, adjust_year(START_DATE_EXAM, i))
    
    print("\tWriting results to file")
    df1 = pd.DataFrame(students, columns=["Pesel", "Imie", "Nazwisko"])
    df2 = pd.DataFrame(classes, columns=["Nazwa_klasy", "Rok_szkolny"])
    df3 = pd.DataFrame(subjects, columns=["ID_Przedmiotu", "Nazwa"])
    df4 = pd.DataFrame(student_in_class, columns=["ID_Ucznia_w_klasie", "Pesel", "Nazwa_klasy"])
    df5 = pd.DataFrame(end_year, columns=["ID_Ucznia_w_klasie", "ID_Przedmiotu", "Ocena", "Frekwencja"])
    df6 = pd.DataFrame(results, columns=["Pesel", "Przedmiot", "Wynik", "Data_matury"])

    df1.to_csv(f"dane/t{i+1}/uczniowie.csv", index=False)
    df2.to_csv(f"dane/t{i+1}/klasy.csv", index=False)
    df3.to_csv(f"dane/t{i+1}/przedmioty.csv", index=False)
    df4.to_csv(f"dane/t{i+1}/uczen_w_klasie.csv", index=False)
    df5.to_csv(f"dane/t{i+1}/koniec_roku.csv", index=False)
    df6.to_csv(f"dane/t{i+1}/wyniki.csv", index=False)

print("All done!")

