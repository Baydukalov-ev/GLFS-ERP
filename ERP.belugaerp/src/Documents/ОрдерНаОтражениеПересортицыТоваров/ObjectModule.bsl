#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПересортицаТоваров") Тогда
		ЗаполнитьНаОснованииПересортицыТоваров(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииПересортицыТоваров(ПересортицаТоваров)	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПересортицаТоваров.Ссылка КАК Распоряжение,
	|	ПересортицаТоваров.Склад КАК Склад
	|ИЗ
	|	Документ.ПересортицаТоваров КАК ПересортицаТоваров
	|ГДЕ
	|	ПересортицаТоваров.Ссылка = &ПересортицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПересортицаТоваровТовары.Номенклатура КАК Номенклатура,
	|	ПересортицаТоваровТовары.Характеристика КАК Характеристика,
	|	ПересортицаТоваровТовары.Серия КАК Серия,
	|	ПересортицаТоваровТовары.Назначение КАК Назначение,
	|	ПересортицаТоваровТовары.Количество КАК Количество,
	|	ПересортицаТоваровТовары.Количество КАК КоличествоУпаковок,
	|	ПересортицаТоваровТовары.Количество КАК КоличествоОприходование,
	|	ПересортицаТоваровТовары.НоменклатураОприходование КАК НоменклатураОприходование,
	|	ПересортицаТоваровТовары.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|	ПересортицаТоваровТовары.СерияОприходование КАК СерияОприходование,
	|	ПересортицаТоваровТовары.НазначениеОприходование КАК НазначениеОприходование
	|ИЗ
	|	Документ.ПересортицаТоваров.Товары КАК ПересортицаТоваровТовары
	|ГДЕ
	|	ПересортицаТоваровТовары.Ссылка = &ПересортицаТоваров";
	Запрос.УстановитьПараметр("ПересортицаТоваров", ПересортицаТоваров);
	Результат = Запрос.ВыполнитьПакет();
	
	ДанныеШапки = Результат[Результат.ВГраница() - 1].Выбрать();
	Если ДанныеШапки.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеШапки);
		бг_Распоряжение = ДанныеШапки.Распоряжение;
	КонецЕсли;	
	
	Товары.Загрузить(Результат[Результат.ВГраница()].Выгрузить());	
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект,
						Документы.ОрдерНаОтражениеПересортицыТоваров);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
