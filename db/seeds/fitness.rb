# obj = Fitness.create(name: "トレーニング", company_id: 1)
# a = FitnessSecond.create(name: "胸", fitness_id: obj.id)
# menu_a = ["ベンチプレス","インクラインベンチプレス","デクラインベンチプレス",
# "ダンベルフライ","ダンベルプレス","インクラインダンベルプレス","インクラインダンベルフライ",
# "ダンベルプルオーバー","プッシュアップ","ディップス"]
# menu_a.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: a.id, set: true, weight: true, fitness_second_name: a.name)
# end
# b = FitnessSecond.create(name: "背中", fitness_id: obj.id)
# menu_b = ['ラットプルダウン','シーテッドローイング','チンニング',
#     'ダンベルプルオーバー','ワンハンドローイング','ベントオーバーローイング',
#     'デッドリフト','バックエクステンション','グッドモーニング'
# ]
# menu_b.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: b.id, set: true, weight: true, fitness_second_name: b.name)
# end
# menu_c = ['ミリタリープレス','バックプレス','フロントプレス','バーベルシュラッグ',
#     'アップライトローイング','サイドレイズ','フロントレイズ','リアレイズ','アーノルドプレス','ショルダープレス'
# ]
# c = FitnessSecond.create(name: "肩", fitness_id: obj.id)
# menu_c.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: c.id, set: true, weight: true, fitness_second_name: c.name)
# end
# d = FitnessSecond.create(name: "三頭", fitness_id: obj.id)
# menu_d = ['フレンチプレス','トライセプスエクステンション','ナローベンチプレス','キックバック','プレスダウン','ナロープッシュアップ','リバースプッシュアップ']
# menu_d.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: d.id, set: true, weight: true, fitness_second_name: d.name)
# end
# e = FitnessSecond.create(name: "二頭", fitness_id: obj.id)
# menu_e  = ['バーベルカール','プリチャーカール','ダンベルカール','コンセントレーションカール','インクラインカール','ハンマーカール','ケーブルカール']
# menu_e.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: e.id, set: true, weight: true, fitness_second_name: e.name)
# end
# f = FitnessSecond.create(name: "腹筋", fitness_id: obj.id)
# menu_f = ['プランク','サイドプランク','サイドベント','シットアップ','クランチ','リバースクランチ','ヒップレイズ','レッグレイズ','ハンギングレッグレイズ','クロスクランチ','バイシクル']
# menu_f.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: f.id, set: false, weight: false, fitness_second_name: f.name)
# end
# g = FitnessSecond.create(name: "下半身", fitness_id: obj.id)
# menu_f = ['フロントスクワット','ワイドスクワット','フロントランジ','サイドランジ','バックランジ','ステーショナリーランジ','レッグエクステンション',
#     'レッグカール','カーフレイズ','シングルレッグスクワット','ブルガリアンスクワット','シングルレッグデッドリフト','ルーマニアンデッドリフト','アブダクション',
#     'アダクション','シェル','ヒップリフト','シングルレッグヒップリフト','立位中殿','立位キック','バックキック','ヒップアブダクション'
# ]
# menu_f.each do |m|
#     FitnessThird.create(name: m, fitness_second_id: f.id, set: true, weight: true, fitness_second_name: g.name)
# end