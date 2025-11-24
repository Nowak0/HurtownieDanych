from faker import Faker
import pandas as pd
import random
import math

NUMBER_OF_SUBJECTS = 3
NUMBER_OF_STUDENTS = 30
START_DATE_SCHOOL = "2024-09-01"
START_DATE_EXAM = "2025-05-01"

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

def random_frequency():
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
        return int(value)

def filter_students(student_in_class, class_number):
    filtered_students = []
    for i in range(len(student_in_class)):
        if int(student_in_class[i]["Nazwa_klasy"][0]) == class_number:
            filtered_students.append(student_in_class[i])

    return filtered_students

def check_pid(pesel):
    if len(pesel) != 11:
        return False
    if int(pesel[2:4]) > 12:
        return False
    if int(pesel[0:2]) < 90:
        return False

    return True

def generate_students(length, faker):
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
            "IDPrzedmiotu": i,
            "Nazwa": name
        })
        i+=1

    return subjects

def generate_end_year(student_in_class):
    end_year = []
    for i in range(len(student_in_class)):
        for j in range(NUMBER_OF_SUBJECTS):
            end_year.append({
                "ID_Ucznia_w_klasie": i+1,
                "IDPrzedmiotu": j+1,
                "Ocena": random_grade(),
                "Frekwencja": random_frequency()
            })
    return end_year

def generate_student_in_class(students, classes):
    student_in_class = []
    for i in range(len(students)):
        this_class = random.choice(classes)
        student_in_class.append({
            "ID_Ucznia_w_klasie": i+1,
            "Pesel": students[i]['Pesel'],
            "Nazwa_klasy": this_class['Nazwa_klasy']
        })
    return student_in_class

def generate_results(student_in_class, subjects, exam_date):
    results = []
    exam_students = filter_students(student_in_class, 4)
    len_exam_students = len(exam_students)
    attended = len_exam_students
    if len_exam_students > 10:
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

faker = Faker("pl_PL")
students = generate_students(NUMBER_OF_STUDENTS, faker)
classes = generate_classes(START_DATE_SCHOOL)
subjects = generate_subjects()
end_year = generate_end_year(students)
student_in_class = generate_student_in_class(students, classes)
results = generate_results(student_in_class, subjects, START_DATE_EXAM)

df1 = pd.DataFrame(students, columns=["Pesel", "Imie", "Nazwisko"])
df2 = pd.DataFrame(classes, columns=["Nazwa_klasy", "Rok_szkolny"])
df3 = pd.DataFrame(subjects, columns=["IDPrzedmiotu", "Nazwa"])
df4 = pd.DataFrame(student_in_class, columns=["ID_Ucznia_w_klasie", "Pesel", "Nazwa_klasy"])
df5 = pd.DataFrame(end_year, columns=["ID_Ucznia_w_klasie", "IDPrzedmiotu", "Ocena", "Frekwencja"])
df6 = pd.DataFrame(results, columns=["Pesel", "Przedmiot", "Wynik", "Data_matury"])

df1.to_csv("dane/uczniowie.csv", index=False)
df2.to_csv("dane/klasy.csv", index=False)
df3.to_csv("dane/przedmioty.csv", index=False)
df4.to_csv("dane/uczen_w_klasie.csv", index=False)
df5.to_csv("dane/koniec_roku.csv", index=False)
df6.to_csv("dane/wyniki.csv", index=False)

