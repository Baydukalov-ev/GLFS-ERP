#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		ЗаказКлиента = Параметры.ПараметрКоманды;
		Сформировать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьОтчетДляСогласованияСБ(Команда)
	
	Сформировать();
	
КонецПроцедуры  

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Сформировать()
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.Вывести(Обработки.бг_СогласованиеПродаж.ОтчетДляСогласованияСБПоЗаказуКлиента(ЗаказКлиента));
	
КонецПроцедуры

#КонецОбласти