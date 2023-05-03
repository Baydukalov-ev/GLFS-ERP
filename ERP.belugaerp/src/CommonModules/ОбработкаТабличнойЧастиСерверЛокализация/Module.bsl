
#Область СлужебныйПрограммныйИнтерфейс

&После("ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВСтрокеТЧ")
Процедура бг_ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий,
	КэшированныеЗначения, СтруктураДействийЗаполнения)
	
	Перем СтруктураПараметровДействия;
	
	Если СтруктураДействий.Свойство("бг_ЗаполнитьПризнакИспользоватьДатуПроизводстваСерии", СтруктураПараметровДействия)
		И ЗначениеЗаполнено(СтруктураПараметровДействия) Тогда
		
		СтруктураДействийЗаполнения.Вставить(
			"бг_ЗаполнитьПризнакИспользоватьДатуПроизводстваСерии",
			СтруктураПараметровДействия);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
