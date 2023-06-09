#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСуммуАкциза(Объект, ТабличнаяЧасть, ВыделенныеСтроки = Неопределено) Экспорт

	Если ТабличнаяЧасть.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получение выгрузки по табличной части
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента")
		Или ТипЗнч(Объект) = Тип("ДокументОбъект.ВозвратТоваровОтКлиента") Тогда
		ЭтоВозвратТоваров = Истина;
		КолонкиВыгрузки = "НомерСтроки, Номенклатура, Серия, ДокументРеализации, Количество";
	Иначе
		ЭтоВозвратТоваров = Ложь;
		КолонкиВыгрузки = "НомерСтроки, Номенклатура, Количество";
	КонецЕсли;
	Таблица = ОбщегоНазначенияУТ.ВыгрузитьТаблицуЗначений(
	ТабличнаяЧасть,
	ВыделенныеСтроки,
	КолонкиВыгрузки);
		
	Запрос = Новый Запрос;
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.КорректировкаРеализации")
		Или ТипЗнч(Объект) = Тип("ДокументОбъект.КорректировкаРеализации") Тогда
		Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.ДокументОснование), 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Дата"), ТекущаяДатаСеанса()));
	Иначе
		Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	КонецЕсли;

	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") И ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров")
		Или ТипЗнч(Объект) = Тип("ДокументОбъект.ВнутреннееПотреблениеТоваров") Тогда
		Запрос.УстановитьПараметр("СостояниеСырья", Перечисления.бг_СостоянияПодакцизногоСырья.ВСписанныхМПЗПоНорме);
		Запрос.УстановитьПараметр("ПродажаНаЭкспорт", Ложь);
	Иначе
		Запрос.УстановитьПараметр("СостояниеСырья", Перечисления.бг_СостоянияПодакцизногоСырья.ВРеализованнойПродукции);
		Запрос.УстановитьПараметр("ПродажаНаЭкспорт", Объект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт);
	КонецЕсли;
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Запрос.УстановитьПараметр("КоличествоЛитровВДале", 10);

	Если ЭтоВозвратТоваров Тогда
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.НомерСтроки КАК НомерСтроки,
		|	Таблица.Номенклатура КАК Номенклатура,
		|	ВЫРАЗИТЬ(Таблица.ДокументРеализации КАК Документ.РеализацияТоваровУслуг) КАК ДокументРеализации,
		|	ВЫРАЗИТЬ(Таблица.Серия КАК Справочник.СерииНоменклатуры) КАК Серия,
		|	Таблица.Количество КАК Количество
		|ПОМЕСТИТЬ втТаблицаТоварыПодг
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	втТаблицаТовары.Номенклатура КАК Номенклатура,
		|ВЫБОР 
		|	КОГДА втТаблицаТовары.Серия.бг_ДатаРеализации <> ДАТАВРЕМЯ(1, 1, 1)
		|		ТОГДА втТаблицаТовары.Серия.бг_ДатаРеализации
		|	ИНАЧЕ 
		|		ISNULL(втТаблицаТовары.ДокументРеализации.Дата, &Дата)
		|	КОНЕЦ КАК ДатаПолученияСтавки,
		|	втТаблицаТовары.Количество КАК Количество,
		|	втТаблицаТовары.Количество * втТаблицаТовары.Номенклатура.ОбъемДАЛ * &КоличествоЛитровВДале * втТаблицаТовары.Номенклатура.Крепость / 100 КАК КоличествоЛитровБС
		// Количество литров * Крепость / 100%
		|ПОМЕСТИТЬ втТаблицаТовары
		|ИЗ
		|	втТаблицаТоварыПодг КАК втТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	втТаблицаТовары.Номенклатура КАК Номенклатура,
		|	втТаблицаТовары.Количество КАК Количество,
		|	ЕСТЬNULL(втТаблицаТовары.КоличествоЛитровБС * бг_КодыВидовОперацийНалогообложенияАкцизом.ВидПодакцизныхТоваров.НалоговаяСтавка, 0) КАК СуммаАкциза
		|ИЗ
		|	втТаблицаТовары КАК втТаблицаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бг_НалогообложениеАкцизомОрганизаций КАК НалогообложениеАкцизомОрганизаций
		|		ПО (НалогообложениеАкцизомОрганизаций.Организация = &Организация)
		|			И (НалогообложениеАкцизомОрганизаций.СтатусАкциза = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияОплатыВходящегоАкциза.ПустаяСсылка))
		|			И (НалогообложениеАкцизомОрганизаций.СостояниеСырья = &СостояниеСырья)
		|			И (НалогообложениеАкцизомОрганизаций.СтатусНачисленияАванса = ЗНАЧЕНИЕ(Перечисление.бг_СтатусыНачисленияАвансов.ПустаяСсылка))
		|			И (НалогообложениеАкцизомОрганизаций.ПродажаНаЭкспорт = &ПродажаНаЭкспорт)
		|			И (НалогообложениеАкцизомОрганизаций.Номенклатура В (втТаблицаТовары.Номенклатура, втТаблицаТовары.Номенклатура.ВидНоменклатуры))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_КодыВидовОперацийНалогообложенияАкцизом КАК бг_КодыВидовОперацийНалогообложенияАкцизом
		|		ПО (НалогообложениеАкцизомОрганизаций.ВидОперацииНалогообложения = бг_КодыВидовОперацийНалогообложенияАкцизом.ВидОперацииНалогообложенияАкцизом)
		|			И (бг_КодыВидовОперацийНалогообложенияАкцизом.Период В
		|				(ВЫБРАТЬ
		|					МАКСИМУМ(бг_КодыВидовОперацийНалогообложенияАкцизомПериод.Период)
		|				ИЗ
		|					РегистрСведений.бг_КодыВидовОперацийНалогообложенияАкцизом КАК бг_КодыВидовОперацийНалогообложенияАкцизомПериод
		|				ГДЕ
		|					НалогообложениеАкцизомОрганизаций.ВидОперацииНалогообложения = бг_КодыВидовОперацийНалогообложенияАкцизомПериод.ВидОперацииНалогообложенияАкцизом
		|					И бг_КодыВидовОперацийНалогообложенияАкцизомПериод.Период <= втТаблицаТовары.ДатаПолученияСтавки))";
		
	Иначе
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.НомерСтроки КАК НомерСтроки,
		|	Таблица.Номенклатура КАК Номенклатура,
		|	Таблица.Количество КАК Количество
		|ПОМЕСТИТЬ втТаблицаТоварыПодг
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	втТаблицаТовары.Номенклатура КАК Номенклатура,
		|	втТаблицаТовары.Количество КАК Количество,
		|	втТаблицаТовары.Количество * втТаблицаТовары.Номенклатура.ОбъемДАЛ * &КоличествоЛитровВДале * втТаблицаТовары.Номенклатура.Крепость / 100 КАК КоличествоЛитровБС
		// Количество литров * Крепость / 100%
		|ПОМЕСТИТЬ втТаблицаТовары
		|ИЗ
		|	втТаблицаТоварыПодг КАК втТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	втТаблицаТовары.Номенклатура КАК Номенклатура,
		|	втТаблицаТовары.Количество КАК Количество,
		|	ЕСТЬNULL(втТаблицаТовары.КоличествоЛитровБС * бг_КодыВидовОперацийНалогообложенияАкцизомСрезПоследних.ВидПодакцизныхТоваров.НалоговаяСтавка, 0) КАК СуммаАкциза
		|ИЗ
		|	втТаблицаТовары КАК втТаблицаТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бг_НалогообложениеАкцизомОрганизаций КАК НалогообложениеАкцизомОрганизаций
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_КодыВидовОперацийНалогообложенияАкцизом.СрезПоследних(&Дата, ) КАК бг_КодыВидовОперацийНалогообложенияАкцизомСрезПоследних
		|			ПО НалогообложениеАкцизомОрганизаций.ВидОперацииНалогообложения = бг_КодыВидовОперацийНалогообложенияАкцизомСрезПоследних.ВидОперацииНалогообложенияАкцизом
		|		ПО (НалогообложениеАкцизомОрганизаций.Организация = &Организация)
		|			И (НалогообложениеАкцизомОрганизаций.СтатусАкциза = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияОплатыВходящегоАкциза.ПустаяСсылка))
		|			И (НалогообложениеАкцизомОрганизаций.СостояниеСырья = &СостояниеСырья)
		|			И (НалогообложениеАкцизомОрганизаций.СтатусНачисленияАванса = ЗНАЧЕНИЕ(Перечисление.бг_СтатусыНачисленияАвансов.ПустаяСсылка))
		|			И (НалогообложениеАкцизомОрганизаций.ПродажаНаЭкспорт = &ПродажаНаЭкспорт)
		|			И (НалогообложениеАкцизомОрганизаций.Номенклатура В (втТаблицаТовары.Номенклатура, втТаблицаТовары.Номенклатура.ВидНоменклатуры))";
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТабличнойЧасти = ТабличнаяЧасть[Выборка.НомерСтроки-1];
		СтрокаТабличнойЧасти.бг_СуммаАкциза = Выборка.СуммаАкциза;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
