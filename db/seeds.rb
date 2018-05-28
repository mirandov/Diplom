# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
cd_1  = ClassDisease.create!(id: 1, name: "Инфекционные и паразитарные болезни", code: "A00-B99")
cd_2  = ClassDisease.create!(id: 2, name: "Новообразования", code: "C00-D48")
cd_3  = ClassDisease.create!(id: 3, name: "Болезни крови, кроветворных органов", code: "D50-D89")
cd_4  = ClassDisease.create!(id: 4, name: "Болезни эндокрийной системы", code: "E00-E90")
cd_5  = ClassDisease.create!(id: 5, name: "Психические расстройства и расстройства поведения", code: "F00-F99")
cd_6  = ClassDisease.create!(id: 6, name: "Болезни нервной системы", code: "G00-G99")
cd_7  = ClassDisease.create!(id: 7, name: "Болезни глаза и его придаточного аппарата", code: "H00-H59")
cd_8  = ClassDisease.create!(id: 8, name: "Болезни уха и сосцевидного отростка", code: "H60-H95")
cd_9  = ClassDisease.create!(id: 9, name: "Болезни системы кровообращения", code: "I00-I99")
cd_10 = ClassDisease.create!(id: 10, name: "Болезни органов дахыния", code: "J00-J99")
cd_11 = ClassDisease.create!(id: 11, name: "Болезни органов пищеварения", code: "K00-K93")
cd_12 = ClassDisease.create!(id: 12, name: "Болезни кожи и подкожной клечатки", code: "L00-L99")
cd_13 = ClassDisease.create!(id: 13, name: "Болезни костно-мышечной системы и соединительной ткани", code: "M00-M99")
cd_14 = ClassDisease.create!(id: 14, name: "Болезни мочеполовой системы", code: "N00-N99")
cd_15 = ClassDisease.create!(id: 15, name: "Врождённые аномалии", code: "Q00-Q99")
cd_16 = ClassDisease.create!(id: 16, name: "Симптомы, признаки и отклоненния от нормы", code: "R00-R99")
cd_17 = ClassDisease.create!(id: 17, name: "Травмы, отравления и др.", code: "S00-T98")
