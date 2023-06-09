
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация", Организация);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлатежныеПоручения

&НаКлиенте
Процедура ПлатежныеПорученияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПлатежныеПоручения.Добавить().Документ = ВыбранноеЗначение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Закрыть(ПодобранныеПлатежныеПоручения());
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборДокументов(Команда)
	
	ОтборВФормеПодбора = Новый Структура("Организация, Проведен, ПроведеноБанком", Организация, Истина, Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("Отбор", ОтборВФормеПодбора);
	
	ОткрытьФорму("Документ.ПоступлениеБезналичныхДенежныхСредств.ФормаВыбора",
		ПараметрыФормы, Элементы.ПлатежныеПоручения,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодобранныеПлатежныеПоручения()
	
	Возврат ПлатежныеПоручения.Выгрузить(, "Документ").ВыгрузитьКолонку("Документ");
	
КонецФункции

#КонецОбласти
