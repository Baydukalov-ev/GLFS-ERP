#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодНСИ",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_КодНСИ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ПорядокВывода",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ПорядокВывода");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_МетодГруппировкиВКПК",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_МетодГруппировкиВКПК");
	
КонецПроцедуры

#КонецОбласти
