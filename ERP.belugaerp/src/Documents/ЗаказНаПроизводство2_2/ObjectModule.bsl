#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	бг_ЗаполнитьСтатусЗаказа();
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	бг_ЗаполнитьСтатусЗаказа();
КонецПроцедуры

&Вместо("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	ТаблицаПродукция = Продукция.Выгрузить(, "Номенклатура");
	Если РегистрыСведений.бг_УстаревшаяНоменклатура.ЕстьУстаревшаяНоменклатураВТаблице(ТаблицаПродукция, "Номенклатура", Дата) Тогда
		Отказ = Истина;
	Иначе 
		ПродолжитьВызов(Отказ, РежимПроведения);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ЗаполнитьСтатусЗаказа()
	Статус = Перечисления.СтатусыЗаказовНаПроизводство2_2.КПроизводству;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
