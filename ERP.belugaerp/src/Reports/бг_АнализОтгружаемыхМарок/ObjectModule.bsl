#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт

	Если Форма.Параметры.Свойство("ТТНИсходящаяЕГАИС") Тогда

		НовыеНастройкиКД.ПараметрыДанных.УстановитьЗначениеПараметра(
			Новый ПараметрКомпоновкиДанных("ТТНИсходящаяЕГАИС"),
			Форма.Параметры.ТТНИсходящаяЕГАИС);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОсновнаяСхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОсновнаяСхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПараметрТТНИсходящаяЕГАИС = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ТТНИсходящаяЕГАИС"));
		
	ТТНИсходящаяЕГАИС = ПараметрТТНИсходящаяЕГАИС.Значение;
	
	ВнешниеНаборыДанных = Новый Структура("ОтгружаемыеМарки", ОтгружаемыеМарки(ТТНИсходящаяЕГАИС));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтгружаемыеМарки(ТТНИсходящаяЕГАИС)
	
	// Проверяем входные данные.
	Если Не (ТипЗнч(ТТНИсходящаяЕГАИС) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС")
		И ЗначениеЗаполнено(ТТНИсходящаяЕГАИС)) Тогда
		
		ВызватьИсключение НСтр("ru='Отчет формируется только по заполненному документу ""ТТН исходящая ЕГАИС"".'");
	КонецЕсли;
	
	РеализацияТоваровУслуг = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТТНИсходящаяЕГАИС, "ДокументОснование");
	Если Не (ТипЗнч(РеализацияТоваровУслуг) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		И ЗначениеЗаполнено(РеализацияТоваровУслуг)) Тогда
		
		ВызватьИсключение НСтр("ru='Отчет формируется только для ТТН по основанию ""Реализация товаров и услуг"".'");
	КонецЕсли;
	
	ОтгружаемыеМарки = НовыйОтгружаемыеМарки();
	
	// Получаем отгружаемые по ТТН марки и упаковки (аналогичным образом, как они отправляются в ЕГАИС).
	ДанныеОтгружаемыхШтрихкодов = Документы.ТТНИсходящаяЕГАИС.бг_ДанныеОтгружаемыхШтрихкодов(
		ТТНИсходящаяЕГАИС,
		РеализацияТоваровУслуг,
		Ложь);
		
	Если ДанныеОтгружаемыхШтрихкодов = Неопределено Тогда
			
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Не найдены данные отгружаемых штрихкодов'"));
			
		Возврат ОтгружаемыеМарки;
	КонецЕсли;
	
	// Проверяем соответствие отгружаемых марок и алкогольной продукции в ТТН.
	МаркиСоответствуютАлкогольнойПродукцииТТН = Документы.ТТНИсходящаяЕГАИС.бг_МаркиСоответствуютАлкогольнойПродукцииТТН(
		ДанныеОтгружаемыхШтрихкодов.Марки,
		ТТНИсходящаяЕГАИС);	
		
	Если Не МаркиСоответствуютАлкогольнойПродукцииТТН Тогда
			
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru='Отгружаемые штрихкоды не соответствуют алкогольной продукции'"));
			
	КонецЕсли;
		
	ЕстьРасхождения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТТНИсходящаяЕГАИС, "ЕстьРасхождения");
	Если ЕстьРасхождения Тогда
		НеподтвержденныеМарки = Документы.ТТНИсходящаяЕГАИС.НеподтвержденныеАкцизныеМарки(ТТНИсходящаяЕГАИС);
	КонецЕсли;
	
	// Преобразовываем полученные данные в необходимую для отчета структуру.
	// Для упрощения реализации формируем отчет конкретно под трехуровневую структуру паллетирования.
	ДанныеОтгружаемыхШтрихкодов.Упаковки.Индексы.Добавить("КодУпаковки");
	
	Для каждого СтрокаМарки Из ДанныеОтгружаемыхШтрихкодов.Марки Цикл
			
		НоваяСтрокаОтгружаемыеМарки = ОтгружаемыеМарки.Добавить();
		
		ЗаполнитьЗначенияСвойств(
			НоваяСтрокаОтгружаемыеМарки,
			СтрокаМарки,
			"НомерСтрокиТТН, Номенклатура, Серия, АлкогольнаяПродукция, Справка2");
			
		НоваяСтрокаОтгружаемыеМарки.КодМарки = СтрокаМарки.ИдентификаторМарки;
		НоваяСтрокаОтгружаемыеМарки.КодКоробки = СтрокаМарки.КодУпаковки;
		НоваяСтрокаОтгружаемыеМарки.КоличествоПлан = 1;
		
		Если ЕстьРасхождения Тогда
			Если НеподтвержденныеМарки.Получить(СтрокаМарки.ИдентификаторМарки) = Неопределено Тогда
				НоваяСтрокаОтгружаемыеМарки.КоличествоФакт = 1;
			КонецЕсли;
		КонецЕсли;
			
		ПараметрыПоискаПаллеты = Новый Структура("КодУпаковки", СтрокаМарки.КодУпаковки);
		НайденныеСтрокиПаллета = ДанныеОтгружаемыхШтрихкодов.Упаковки.НайтиСтроки(ПараметрыПоискаПаллеты);
		Если НайденныеСтрокиПаллета.Количество() = 1 Тогда
			НоваяСтрокаОтгружаемыеМарки.КодПаллеты = НайденныеСтрокиПаллета[0].КодВышестоящейУпаковки;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОтгружаемыеМарки;	

КонецФункции

Функция НовыйОтгружаемыеМарки()

	ОтгружаемыеМарки = Новый ТаблицаЗначений;
	
	ОтгружаемыеМарки.Колонки.Добавить(
		"НомерСтрокиТТН",
		ОбщегоНазначения.ОписаниеТипаЧисло(5));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"АлкогольнаяПродукция",
		Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"Номенклатура",
		Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"Серия",
		Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"Справка2",
		Новый ОписаниеТипов("СправочникСсылка.Справки2ЕГАИС"));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"КодПаллеты",
		Метаданные.РегистрыСведений.бг_ДвижениеМарок.Ресурсы.КодУпаковки.Тип);
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"КодКоробки",
		Метаданные.РегистрыСведений.бг_ДвижениеМарок.Ресурсы.КодУпаковки.Тип);
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"КодМарки",
		Метаданные.РегистрыСведений.бг_ИдентификаторыМарок.Ресурсы.ИдентификаторМарки.Тип);
										
	ОтгружаемыеМарки.Колонки.Добавить(
		"КоличествоПлан",
		ОбщегоНазначения.ОписаниеТипаЧисло(10));
		
	ОтгружаемыеМарки.Колонки.Добавить(
		"КоличествоФакт",
		ОбщегоНазначения.ОписаниеТипаЧисло(10));
		
	Возврат ОтгружаемыеМарки;
		
КонецФункции

#КонецОбласти

#КонецЕсли
