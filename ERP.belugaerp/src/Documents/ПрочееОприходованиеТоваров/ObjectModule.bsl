
#Область ОбработчикиСобытий

&После("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Или Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ОбщиеМеханизмы.АктуализацияСерийДокумента
	АктуализироватьСерии();
	// Конец ОбщиеМеханизмы.АктуализацияСерийДокумента
	
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	
	бг_ИнвентаризацияПродукцииЕГАИС = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АктуализацияСерий

// ОбщиеМеханизмы.АктуализацияСерийДокумента
Процедура АктуализироватьСерии()
	
	КлючевыеПоля = "Серия";
	
	СерииДокумента = ОбщегоНазначенияУТ.ВыгрузитьТаблицуЗначений(
		Товары,,
		КлючевыеПоля);
		
	СерииДокумента.Свернуть(КлючевыеПоля);
	
	СерииКАктуализации = СерииКАктуализации(СерииДокумента);
	
	Для каждого ДанныеСерииКАктуализации Из СерииКАктуализации Цикл
		АктуализироватьСерию(ДанныеСерииКАктуализации);
	КонецЦикла;
	
КонецПроцедуры

Функция СерииКАктуализации(СерииДокумента)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СерииДокумента.Серия КАК Серия
	|ПОМЕСТИТЬ СерииДокумента
	|ИЗ
	|	&СерииДокумента КАК СерииДокумента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СерииДокумента.Серия КАК Серия
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СправочникСерииНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СерииДокумента КАК СерииДокумента
	|		ПО (СерииДокумента.Серия = СправочникСерииНоменклатуры.Ссылка)
	|ГДЕ
	|	СправочникСерииНоменклатуры.бг_ДокументВыпуска <> &ДокументВыпуска";
	
	Запрос.УстановитьПараметр("СерииДокумента", СерииДокумента);
	Запрос.УстановитьПараметр("ДокументВыпуска", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Процедура АктуализироватьСерию(ДанныеСерииКАктуализации)
	
	СерияОбъект = ДанныеСерииКАктуализации.Серия.ПолучитьОбъект();
	СерияОбъект.бг_ДокументВыпуска = Ссылка;
	СерияОбъект.Записать();
	
КонецПроцедуры
// Конец ОбщиеМеханизмы.АктуализацияСерийДокумента

#КонецОбласти // Конец АктуализацияСерий

#КонецОбласти
