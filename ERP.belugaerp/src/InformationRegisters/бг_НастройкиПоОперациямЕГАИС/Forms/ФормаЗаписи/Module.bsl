
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.МаксимальноеКоличествоВПорцииОбмена.РасширеннаяПодсказка.Заголовок = 
		СтрШаблон(НСтр("ru = '(Всего %1)'", ОбщегоНазначения.КодОсновногоЯзыка()),
			XMLСтрока(бг_КонстантыПовтИсп.ЗначениеКонстанты("КоличествоДокументовВПорцииОбменаЕГАИС")));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПриоритетПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура МаксимальноеКоличествоВПорцииОбменаРасширеннаяПодсказкаНажатие(Элемент)
	
	ФормаНастроек = ПолучитьФорму("РегистрСведений.бг_ЗначенияДополнительныхКонстант.Форма.ФормаНастроек");
	СтраницаСНастройкой = ФормаНастроек.Элементы.Найти("ГруппаРазделЕГАИС");
	Если Не СтраницаСНастройкой = Неопределено Тогда
		ФормаНастроек.Элементы.СтраницыРазделовКонстантПерезаполняемая.ТекущаяСтраница = СтраницаСНастройкой;
	КонецЕсли;
	ФормаНастроек.ТекущийЭлемент = ФормаНастроек.Элементы.ПолеКонстантаКоличествоДокументовВПорцииОбменаЕГАИС;
	ФормаНастроек.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеДоступностью()
	
	ДоступнаНастройкаОграничения = (Запись.Приоритет > 1);
	Элементы.МаксимальноеКоличествоВПорцииОбмена.Доступность = ДоступнаНастройкаОграничения;
	Элементы.ИнтервалРегистрации.Доступность = ДоступнаНастройкаОграничения;
	Элементы.ИнтервалОтправки.Доступность = ДоступнаНастройкаОграничения;
	
КонецПроцедуры

#КонецОбласти