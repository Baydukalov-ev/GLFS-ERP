#Область ПрограммныйИнтерфейс

&Вместо("ЕстьРасхожденияВПолученныхДанных")
Функция бг_ЕстьРасхожденияВПолученныхДанных(ДокументСсылка, ИмяОтчета) Экспорт
	Если ВРег(ИмяОтчета) = Врег("ОстаткиАкцизныхМарокЕГАИС") Тогда
		Возврат ПродолжитьВызов(ДокументСсылка, "бг_ОстаткиАкцизныхМарокЕГАИС");
	Иначе 
		Возврат ПродолжитьВызов(ДокументСсылка, ИмяОтчета);
	КонецЕсли;
КонецФункции

&Вместо("РасхожденияВПолученныхДанных")
Функция бг_РасхожденияВПолученныхДанных(ДокументСсылка, ИмяОтчета) Экспорт
	Если ВРег(ИмяОтчета) = Врег("ОстаткиАкцизныхМарокЕГАИС") Тогда
		Возврат ПродолжитьВызов(ДокументСсылка, "бг_ОстаткиАкцизныхМарокЕГАИС");
	Иначе 
		Возврат ПродолжитьВызов(ДокументСсылка, ИмяОтчета);
	КонецЕсли;
КонецФункции
	
#КонецОбласти
