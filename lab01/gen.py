import csv
import random
from datetime import datetime, timedelta, time
from faker import Faker

N = 1000

fake = Faker()

def write_to_csv(filename, data, headers):
    with open(filename, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        writer.writerows(data)

def generate_random_date(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    return start_date + timedelta(days=random_days)

def generate_medicines():
    meds = []
    for i in range(1, N + 1):
        tittle = fake.word() + ' ' + fake.word()
        manufacturer = fake.name()
        price = random.randint(50, 5000)
        date = generate_random_date(datetime(2025, 1, 1), datetime(2035, 1, 1))
        meds.append([i, tittle, manufacturer, price, date.date()])
    write_to_csv('meds.csv', meds,['med_id', 'tittle', 'distributor', 'price', 'expiration_date'])

def generate_availabilities():
    availabilities = []
    fk_pairs = []
    for i in range(1, N + 1):
        for j in range(1, N + 1):
            fk_pairs.append([i, j])
    random.shuffle(fk_pairs)
    for i in range(1, N + 1):
        med_id, pharmacy_id = fk_pairs[i][0], fk_pairs[i][1]
        cnt = random.randint(0, 50)
        availabilities.append([med_id, pharmacy_id, cnt])
    write_to_csv('./csv_data/availabilities.csv', availabilities, ['med_id', 'pharmacy_id', 'cnt'])

def generate_pharmacies():
    pharmacies = []
    for i in range(1, N + 1):
        city = fake.city()
        street = fake.street_name()
        house = random.randint(1, 50)
        pharmacies.append([i, city, street, house])
    write_to_csv('./csv_data/pharmacies.csv', pharmacies, ['pharmacy_id', 'city', 'street', 'house'])

def generate_employers():
    employers = []
    positions = ['pharmacist', 'chemist', 'packer', 'cleaner', 'cashier']
    for i in range(1, N + 1):
        pharmacy_id = random.randint(1, N)
        FIO = fake.name()
        position = positions[random.randint(0, 4)]
        price = random.randint(40000, 150000)
        employers.append([i, pharmacy_id, FIO, position, price])
    write_to_csv('./csv_data/employers.csv', employers, ['employer_id', 'pharmacy_id', 'FIO', 'position', 'price'])

generate_medicines()
generate_availabilities()
generate_pharmacies()
generate_employers()