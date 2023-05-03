#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	бг_УстановитьАвтоматическиФормироватьЗаявкиНаРасходованиеДС();
	
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	
	бг_УстановитьАвтоматическиФормироватьЗаявкиНаРасходованиеДС();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_УстановитьАвтоматическиФормироватьЗаявкиНаРасходованиеДС()
	
	бг_АвтоматическиФормироватьЗаявкиНаРасходованиеДС = 
		бг_Магистраль.АвтоматическиФормироватьЗаявкиНаРасходованиеДС(Договор);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
