#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	бг_ЗаполнитьСтатьюКалькуляции();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ЗаполнитьСтатьюКалькуляции()
	
	бг_Номенклатура.ЗаполнитьСтатьюКалькуляцииВТЧИзНоменклатуры(ЭтотОбъект, "МатериалыИУслуги");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли