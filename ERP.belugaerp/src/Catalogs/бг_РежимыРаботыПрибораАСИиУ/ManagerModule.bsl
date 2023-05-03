#Область ПрограммныйИнтерфейс

// Создает предопределенные элементы справочника
//
Процедура СоздатьЭлементыПоУмолчанию() Экспорт
	Макет = ПолучитьМакет("ДанныеКлассификатора");
	ТекущаяСтрока = 1;
	НомерКолонкиUUID = 1;
	НомерКолонкиКод = 2;
	НомерКолонкиНаименование = 4;
	Пока Истина Цикл 
		ТекущаяСтрока = ТекущаяСтрока + 1;
		UUIDСтрока = СокрЛП(Макет.Область(ТекущаяСтрока, НомерКолонкиUUID).Текст);
		Если ПустаяСтрока(UUIDСтрока) Тогда
			Прервать;
		КонецЕсли;
		КодСтрока = СокрЛП(Макет.Область(ТекущаяСтрока, НомерКолонкиКод).Текст);
		НаименованиеСтрока = СокрЛП(Макет.Область(ТекущаяСтрока, НомерКолонкиНаименование).Текст);
		ДобавитьЭлемент(UUIDСтрока, КодСтрока, НаименованиеСтрока);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти 

#Область ПрограммныйИнтерфейс

Процедура ДобавитьЭлемент(UUIDСтрока, Код, Наименование)
	СсылкаНового = Справочники.бг_РежимыРаботыПрибораАСИиУ.ПолучитьСсылку(
		Новый УникальныйИдентификатор(UUIDСтрока));
	Если ОбщегоНазначения.СсылкаСуществует(СсылкаНового) Тогда
		Возврат;
	КонецЕсли;
	ЭлементОбъект = Справочники.бг_РежимыРаботыПрибораАСИиУ.СоздатьЭлемент();
	ЭлементОбъект.УстановитьСсылкуНового(СсылкаНового);
	ЭлементОбъект.Наименование = Наименование;
	ЭлементОбъект.Код = Код;
	ЭлементОбъект.Записать();
КонецПроцедуры

#КонецОбласти 