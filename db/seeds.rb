MasterAdmin.create(email: "admin@gmail.com", password: "111111")
MasterAdmin.create(email: "masteradmin@gmail.com", password: "111111")

Company.create(name: "room")
Company.create(name: "rise-up")

require './db/seeds/fitness.rb'
Fitness.create(name: "ヨガ", company_id: 1)
Fitness.create(name: "整体", company_id: 1)

CustomerMenu.create(name: "整体", company_id: 1)
CustomerMenu.create(name: "トレーニング", company_id: 1)
CustomerMenu.create(name: "整体＋トレーニング", company_id: 1)
CustomerMenu.create(name: "ヨガ", company_id: 1)
CustomerMenu.create(name: "ボクササイズ", company_id: 1)

Store.create(store_name: "代々木上原", store_address: "ああああああああああああああああああああ",number_of_rooms: 3, company_id: 1)
Store.create(store_name: "東北沢", store_address: "ああああああああああああああああああああ",number_of_rooms: 2, company_id: 1)

Admin.create(email: "admin@gmail.com", password: "password", company_id: 1)

Trainer.create(first_name_kanji: "竹中", last_name_kanji: "明", first_name_kana: "たけなか", last_name_kana: "あきら", email: "room-a@gmail.com", password: "aaaaaa", company_id: 1)
Trainer.create(first_name_kanji: "竹中", last_name_kanji: "明", first_name_kana: "たけなか", last_name_kana: "あきら",email: "rise-up-a@gmail.com", password: "aaaaaa", company_id: 1)
Trainer.create(first_name_kanji: "竹中", last_name_kanji: "明", first_name_kana: "たけなか", last_name_kana: "あきら",email: "rise-up-ba@gmail.com", password: "bbbbbb", company_id: 1)
TrainerFitness.create(fitness_id: 1, trainer_id: 1)
TrainerFitness.create(fitness_id: 2, trainer_id: 1)
TrainerFitness.create(fitness_id: 1, trainer_id: 2)
TrainerFitness.create(fitness_id: 3, trainer_id: 2)
TrainerFitness.create(fitness_id: 1, trainer_id: 3)

time = [
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 7, 00, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 7, 50, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 8, 40, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 9, 30, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 10, 20, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 11, 10, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month, Date.today.day, 12, 00, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 12, 50, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 13, 40, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 14, 30, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 15, 20, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 16, 10, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 17, 00, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 17, 50, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 18, 40, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 19, 30, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 20, 20, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 21, 10, 0, 0.375),
    DateTime.new(Date.today.year, Date.today.month,Date.today.day, 22, 00, 0, 0.375)
]
tommorow_a =  DateTime.new(Date.today.year, Date.today.month, Date.today.day + 1, 7, 00, 0, 0.375)
tommorow_b =  DateTime.new(Date.today.year, Date.today.month, Date.today.day + 1, 18, 00, 0, 0.375)

TrainerShift.create(start: time[0], finish: time[12], trainer_id: 1, store_id: 1)
TrainerShift.create(start: time[0], finish: time[12], trainer_id: 2, store_id: 1)
TrainerShift.create(start: time[0], finish: time[15], trainer_id: 3, store_id: 2)
TrainerShift.create(start: tommorow_a, finish: tommorow_b , trainer_id: 1, store_id: 1)
TrainerShift.create(start: tommorow_a, finish: tommorow_b , trainer_id: 2, store_id: 2)

jobs = ["経営者・役員", "公務員", "金融", "コンサル", "保険", "メーカー",
    "商社", "不動産", "広告・マスコミ", "出版", "IT関連", "エンジニア", "医療","営業","主婦"]
jobs.each do |j|
    Job.create(name: j)
end

interests_family = ['健康','生活']
a = InterestFamily.create(name: "健康")
b = InterestFamily.create(name: '生活')
a_interests = ['ダイエット', '腕筋','腹筋', '胸筋','背筋','脚筋','バストアップ','ヒップアップ','二の腕','ウエスト','美脚','お腹',
'減量','増量','健康維持','運動不足解消','脂肪を落とす','ストレッチ','柔軟','整体','有酸素運動','自分磨き','美肌','デトックス']
b_interests = ['ハイキング','登山','キャンプ','旅行','温泉','ドライブ','車','バイク',
    '自転車','サイクリング','ランニング','サーフィン','ダイビング','ゴルフ','サッカー','デザート','邦楽', '洋楽', 'Youtube']

a_interests.each do |a_i|
    Interest.create(name: a_i,interest_family_id: a.id)
end

b_interests.each do |b_i|
    Interest.create(name: b_i,interest_family_id: b.id)
end

a = [
    ["山田","太郎", "やまだ","たろう","1@gmail.com","aaaaaa"],
    ["森","花子", "もり","はなこ","2@gmail.com","aaaaaa"],
    ["加藤","篤", "かとう","あつし","3@gmail.com","aaaaaa"],
    ["安倍","晋三", "あべ","しんぞう","4@gmail.com","aaaaaa"],
    ["伊藤","一十", "いとう","いちじゅう","5@gmail.com","aaaaaa"],
    ["小泉","純一郎", "こいずみ","じゅんいちろう","6@gmail.com","aaaaaa"],
    ["林","かなこ", "はやし","かなこ","7@gmail.com","aaaaaa"],
    ["田中","美佐子", "たなか","みさこ","8@gmail.com","aaaaaa"],
    ["青木","ゆり子", "あおき","ゆりこ","9@gmail.com","aaaaaa"],
    ["稲垣","優香", "いながき","ゆうか","10@gmail.com","aaaaaa"]
]

a.each do |aa|
    c = Customer.create(first_name_kanji: "加藤" , last_name_kanji: "太郎", first_name_kana: "かとう", last_name_kana: "たろう",email: aa[0], password: aa[0], company_id: 1, confirmed_at: DateTime.now)
    f = Customer.create(first_name_kanji: "加藤" , last_name_kanji: "太郎", first_name_kana: "かとう", last_name_kana: "たろう", email: aa[4], password: aa[5], company_id: 1, confirmed_at: DateTime.now)
    CustomerStatus.create(paid: true, room_plus: false, dozen_sessions: false,numbers_of_contractnt: 4, customer_id: c.id)
    CustomerStatus.create(paid: false, room_plus: false, dozen_sessions: false,numbers_of_contractnt: 8, customer_id: f.id)
    CustomerInfo.create(customer_id: c.id, age: 30, address: "愛知県名古屋市守山区白山", gender: "男", phone_number: "098765321", emergency_phone_number: "098765321")
end
Appointment.delete_all && CustomerRecord.delete_all && CustomerRecordSessionMenu.delete_all && Evaluation.delete_all

a = Appointment.create(appointment_time: time[0],customer_id: 1, store_id: 1, fitness_id: 1 ,fitness_name: 'training', finish: true)
b = Appointment.create(appointment_time: time[1],customer_id: 1, store_id: 1, fitness_id: 1 ,fitness_name: 'training', finish: true)
c = Appointment.create(appointment_time:  time[10],customer_id: 1, store_id: 1, fitness_id: 2 ,fitness_name: 'yoga', finish: true)
d = Appointment.create(appointment_time: time[2],customer_id: 1, store_id: 1, fitness_id: 2 ,fitness_name: 'yoga', finish: true)
e = Appointment.create(appointment_time: time[3],customer_id: 1, store_id: 1, fitness_id: 3 ,fitness_name: 'seitai', finish: true)
f = Appointment.create(appointment_time:  time[6],customer_id: 1, store_id: 1, fitness_id: 2 ,fitness_name: 'yoga', finish: true)

aa = CustomerRecord.create(appointment_id: a.id, apo_time: a.appointment_time, customer_id: a.customer_id, trainer_id: 1)
bb = CustomerRecord.create(appointment_id: b.id, apo_time: b.appointment_time,customer_id: b.customer_id, trainer_id: 2)
cc = CustomerRecord.create(appointment_id: c.id, apo_time: c.appointment_time,customer_id: c.customer_id, trainer_id: 2)
dd = CustomerRecord.create(appointment_id: d.id, apo_time: d.appointment_time, customer_id: d.customer_id, trainer_id: 1)
ee = CustomerRecord.create(appointment_id: e.id, apo_time: e.appointment_time,customer_id: e.customer_id, trainer_id: 2)
ff = CustomerRecord.create(appointment_id: f.id, apo_time: f.appointment_time,customer_id: f.customer_id, trainer_id: 1)

CustomerRecordSessionMenu.create(time: 10,weight: 3,fitness_third_id: 1,customer_record_id: aa.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(1).name)
CustomerRecordSessionMenu.create(time: 50,weight: 5,fitness_third_id: 2,customer_record_id: aa.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(2).name)
CustomerRecordSessionMenu.create(time: 1,weight: 1,fitness_third_id: 2,customer_record_id: bb.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(2).name)
CustomerRecordSessionMenu.create(time: 30,weight: 2,fitness_third_id: 3,customer_record_id: bb.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(3).name)
CustomerRecordSessionMenu.create(time: 40,weight: 3,fitness_third_id: 10,customer_record_id: bb.id,fitness_id: 2, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(3).name)
CustomerRecordSessionMenu.create(time: 1,weight: 1,fitness_third_id: 2,customer_record_id: cc.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(4).name)
CustomerRecordSessionMenu.create(time: 30,weight: 2,fitness_third_id: 3,customer_record_id: cc.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(8).name)
CustomerRecordSessionMenu.create(time: 40,weight: 3,fitness_third_id: 10,customer_record_id: cc.id,fitness_id: 2, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(7).name)

CustomerRecordSessionMenu.create(time: 1,weight: 1,fitness_third_id: 2,customer_record_id: dd.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(7).name)
CustomerRecordSessionMenu.create(time: 30,weight: 2,fitness_third_id: 3,customer_record_id: ee.id,fitness_id: 1, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(5).name)
CustomerRecordSessionMenu.create(time: 40,weight: 3,fitness_third_id: 10,customer_record_id: ff.id,fitness_id: 2, fitness_name: Fitness.find(1).name, fitness_third_name: FitnessThird.find(7).name)

Evaluation.create(trainer_id: aa.trainer_id, trainer_name: 'トレーナーA',customer_id: aa.customer_id,customer_record_id: aa.id, trainer_score: 2, food_score: 2)
Evaluation.create(trainer_id: bb.trainer_id, trainer_name: 'Bさん',customer_id: bb.customer_id,customer_record_id: bb.id, trainer_score: 2, food_score: 1)
Evaluation.create(trainer_id: cc.trainer_id, trainer_name: 'Bさん',customer_id: cc.customer_id,customer_record_id: cc.id, trainer_score: 3, food_score: 5)
Evaluation.create(trainer_id: dd.trainer_id, trainer_name: 'トレーナーA',customer_id: dd.customer_id,customer_record_id: dd.id, trainer_score: 3, food_score: 2)
Evaluation.create(trainer_id: ee.trainer_id, trainer_name: 'Bさん',customer_id: ee.customer_id,customer_record_id: ee.id, trainer_score: 3, food_score: 1)
Evaluation.create(trainer_id: ff.trainer_id, trainer_name: 'トレーナーA',customer_id: ff.customer_id,customer_record_id: ff.id, trainer_score: 5, food_score: 5)