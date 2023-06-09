#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗагрузитьИзExcel(Форма, АдресФайла) Экспорт
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	АдресНаСервере = ПолучитьИмяВременногоФайла("xlsx");
	ДвоичныеДанные.Записать(АдресНаСервере);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(АдресНаСервере, СпособЧтенияЗначенийТабличногоДокумента.Текст);
	
	Если ТабличныйДокумент = Неопределено Тогда
		СообщениеОбОшибке = НСтр(
			"ru = 'Файл не может быть загружен.
				|Загружаться могут только файлы, соответствующие формату зарузки.';
			|en = 'The file cannot be imported.
				|You may only import the files conforming to the download format.'");
		
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли; 
	
	
	ДанныеЗаполнения = Форма.ПустыеДанныеДляОтчета();
	ДанныеЗаполнения.Колонки.Добавить("НомерСтрокиФайла", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ПодготовитьДанныеЗаполнения(ДанныеЗаполнения, ТабличныйДокумент);
	
	// Удаляем временный файл.
	Попытка
		УдалитьФайлы(АдресНаСервере);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Подтверждение количества в заявках. Загрузка из Excel'"),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Форма.ЗагрузитьДанныеExcelВПодтверждаемыеТовары(ДанныеЗаполнения);
	Форма.СформироватьОтчетДляВыгрузкиВExcel();
	
КонецПроцедуры

#КонецОбласти 
 
#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеЗаполнения(ДанныеЗаполнения, ТабличныйДокумент)
	
	НомерСтолбцаКонтрагента = 7; // Номер колонки, с которой начинается разбивка по контрагентам.
	КоличествоСтолбцовДляКонтрагента = 2; // Для каждого контрагента предусмотрено две колонкм.
	НомерСтрокиНаименованийКонтрагентов = 1; // Номер строки, в которой записаны наименования контрагентов.
	НомерСтрокиТикеровКонтрагентов = 2; // Номер строки, в которой записаны тикеры контрагентов.
	
	НомерСтолбцаКодаНСИ = 3; // Номер колонки, в которой записаны коды НСИ товарных категорий.
	НомерСтолбцаНаименованийТоварныхКатегорий = 4; // Номер колонки, в которой записаны наименования товарных категорий.
	НомерСтолбцаКодовНСИТоварныхКатегорий = 3; // Номер колонки, в которой записаны коды НСИ товарных категорий.
	
	НомерПервойСтрокиДанных = 4;
	НомерПоследнейСтрокиДанных = ТабличныйДокумент.ВысотаТаблицы - 1;
	КешТоварныхКатегорий = Новый Соответствие;
	
	МассивОшибок = Новый Массив;
	ЗагружаемыеКолонкиКонтрагентов = Новый Соответствие;
	Пока ТабличныйДокумент.ПолучитьОбласть(1, НомерСтолбцаКонтрагента).ТекущаяОбласть.Текст <> "" Цикл
		
		КонтрагентНаименование = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиНаименованийКонтрагентов,
			НомерСтолбцаКонтрагента).ТекущаяОбласть.Текст);
		КонтрагентТикер = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиТикеровКонтрагентов,
			НомерСтолбцаКонтрагента).ТекущаяОбласть.Текст);
		
		Контрагент = КонтрагентПоДаннымФайла(
			КонтрагентНаименование,
			КонтрагентТикер,
			НомерСтрокиНаименованийКонтрагентов,
			НомерСтрокиТикеровКонтрагентов,
			НомерСтолбцаКонтрагента,
			МассивОшибок);
		
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			// Не смогли однозначно найти контрагента ни по тикеру, ни по наименованию.
			// Пропускаем эту колонку.
			ШаблонОшибки = НСтр("ru = 'Данные колонки %1 файла Excel не загружены, не найден контрагент.'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтолбцаКонтрагента);
			МассивОшибок.Добавить(ТекстОшибки);
			НомерСтолбцаКонтрагента = НомерСтолбцаКонтрагента + КоличествоСтолбцовДляКонтрагента;
			Продолжить;
		КонецЕсли;
		
		СтруктураДанныхКонтрагента = Новый Структура;
		СтруктураДанныхКонтрагента.Вставить("Контрагент", Контрагент);
		СтруктураДанныхКонтрагента.Вставить("КонтрагентНаименование", КонтрагентНаименование);
		СтруктураДанныхКонтрагента.Вставить("КонтрагентТикер", КонтрагентТикер);
		ЗагружаемыеКолонкиКонтрагентов.Вставить(НомерСтолбцаКонтрагента, СтруктураДанныхКонтрагента);
		
		НомерСтолбцаКонтрагента = НомерСтолбцаКонтрагента + КоличествоСтолбцовДляКонтрагента;
		
	КонецЦикла; // Цикл по колонкам контрагентов.
	
	ВывестиСообщенияОбОшибках(МассивОшибок);
	МассивОшибок.Очистить();
	
	Если ЗагружаемыеКолонкиКонтрагентов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для НомерСтрокиФайла = НомерПервойСтрокиДанных По НомерПоследнейСтрокиДанных Цикл
		
		ТоварнаяКатегорияНаименование = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиФайла,
			НомерСтолбцаНаименованийТоварныхКатегорий).ТекущаяОбласть.Текст);
		ТоварнаяКатегорияКодНСИ = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиФайла,
			НомерСтолбцаКодовНСИТоварныхКатегорий).ТекущаяОбласть.Текст);
		
		Если Не ЗначениеЗаполнено(ТоварнаяКатегорияКодНСИ) Тогда 
			ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не заполнен Код НСИ товарной категории.'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиФайла, НомерСтолбцаКодовНСИТоварныхКатегорий);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТоварнаяКатегорияНаименование) Тогда 
			ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не заполнено наименование товарной категории.'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиФайла, НомерСтолбцаНаименованийТоварныхКатегорий);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТоварнаяКатегорияКодНСИ) 
			И Не ЗначениеЗаполнено(ТоварнаяКатегорияНаименование) Тогда 
			// Не сможем найти товарную категорию ни по коду НСИ, ни по наименованию.
			// Пропускаем эту строку.
			ШаблонОшибки = НСтр("ru = 'Данные строки %1 файла Excel не загружены, не указана товарная категория.'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиФайла);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		ЗаполнитьДанныеКонтрагентов(
			ТабличныйДокумент,
			ДанныеЗаполнения,
			ЗагружаемыеКолонкиКонтрагентов,
			НомерСтрокиФайла,
			ТоварнаяКатегорияНаименование,
			ТоварнаяКатегорияКодНСИ,
			МассивОшибок);
		
	КонецЦикла; // Цикл по строкам товарных категорий.
	
	// Дозаполним ссылочные данные по товарным категориям. 
	ЗаполнитьДанныеТоварныхКатегорий(ДанныеЗаполнения, МассивОшибок);
	ВывестиСообщенияОбОшибках(МассивОшибок);
	
КонецПроцедуры

Функция КонтрагентПоДаннымФайла(КонтрагентНаименование, 
								КонтрагентТикер,
								НомерСтрокиНаименованийКонтрагентов,
								НомерСтрокиТикеровКонтрагентов,
								НомерСтолбцаКонтрагента,
								МассивОшибок)
	
	Если Не ЗначениеЗаполнено(КонтрагентНаименование) Тогда
		ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не заполнено наименование контрагента.'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиНаименованийКонтрагентов, НомерСтолбцаКонтрагента);
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(КонтрагентТикер) Тогда
		ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не заполнен тикер контрагента.'");
		ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиТикеровКонтрагентов, НомерСтолбцаКонтрагента);
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КонтрагентТикер) Тогда
		Контрагент = бг_ОбщегоНазначенияСервер.КонтрагентПоТикеру(КонтрагентТикер);
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не найден контрагент по тикеру ""%3"".'");
			ТекстОшибки = СтрШаблон(
				ШаблонОшибки,
				НомерСтрокиТикеровКонтрагентов,
				НомерСтолбцаКонтрагента,
				КонтрагентТикер);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(КонтрагентНаименование) Тогда
		Контрагент = КонтрагентПоНаименованию(КонтрагентНаименование);
		Если Не ЗначениеЗаполнено(Контрагент) Тогда
			ШаблонОшибки = НСтр("ru = 'Ячейка R%1C%2 файла Excel, не найден контрагент по наименованию ""%3"".'");
			ТекстОшибки = СтрШаблон(
				ШаблонОшибки,
				НомерСтрокиНаименованийКонтрагентов,
				НомерСтолбцаКонтрагента,
				КонтрагентНаименование);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
	Иначе
		Контрагент = Неопределено;
	КонецЕсли;
	
	Возврат Контрагент;
	
КонецФункции

Функция КонтрагентПоНаименованию(Наименование)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Возврат Контрагент;
	КонецЕсли;
	
	Запрос= Новый Запрос;
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	Контрагенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	НЕ Контрагенты.ПометкаУдаления
	|	И Контрагенты.Наименование = &Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			Контрагент = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Контрагент; 
	
КонецФункции

Процедура ЗаполнитьДанныеКонтрагентов(ТабличныйДокумент,
										ДанныеЗаполнения,
										ЗагружаемыеКолонкиКонтрагентов,
										НомерСтрокиФайла,
										ТоварнаяКатегорияНаименование,
										ТоварнаяКатегорияКодНСИ,
										МассивОшибок)
	
	Для Каждого КолонкаКонтрагента Из ЗагружаемыеКолонкиКонтрагентов Цикл
		
		НомерСтолбцаКонтрагента = КолонкаКонтрагента.Ключ;
		ДанныеКонтрагента = КолонкаКонтрагента.Значение;
		
		ЗаказаноСтрокой = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиФайла,
			НомерСтолбцаКонтрагента).ТекущаяОбласть.Текст);
		ОтказЗаказано = Ложь;
		Заказано = ЧислоИзСтроки(ЗаказаноСтрокой, ОтказЗаказано);
		
		Если ОтказЗаказано Тогда
			ШаблонОшибки = НСтр(
				"ru = 'Ячейка R%1C%2 файла Excel, не удалось преобразовать в число значение ""%3"".'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиФайла, НомерСтолбцаКонтрагента, ЗаказаноСтрокой);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		ПодтвержденоСтрокой = СокрЛП(ТабличныйДокумент.ПолучитьОбласть(
			НомерСтрокиФайла,
			НомерСтолбцаКонтрагента + 1).ТекущаяОбласть.Текст);
		ОтказПодтверждено = Ложь;
		Подтверждено = ЧислоИзСтроки(ПодтвержденоСтрокой, ОтказПодтверждено);
		
		Если ОтказПодтверждено Тогда
			ШаблонОшибки = НСтр(
				"ru = 'Ячейка R%1C%2 файла Excel, не удалось преобразовать в число значение ""%3"".'");
			ТекстОшибки = СтрШаблон(
				ШаблонОшибки, 
				НомерСтрокиФайла,
				НомерСтолбцаКонтрагента + 1,
				ПодтвержденоСтрокой);
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		Если ОтказЗаказано Или ОтказПодтверждено Тогда
			// Если не смогли преобразовать данные количеств в числа, то загружать не будем.
			// Загружать нули нельзя, так как ноль это это равноправное число, и считать,
			// что любая "абракодабра" это ноль - некорректно.
			ШаблонОшибки = НСтр(
				"ru = 'Данные строки %1 файла Excel по контрагенту %2 не загружены.'");
			ТекстОшибки = СтрШаблон(
				ШаблонОшибки,
				НомерСтрокиФайла,
				ДанныеКонтрагента.Контрагент);
			МассивОшибок.Добавить(ТекстОшибки);
			Продолжить;
		КонецЕсли;
		
		СтрокаДанныхЗаполнения = ДанныеЗаполнения.Добавить();
		СтрокаДанныхЗаполнения.НомерСтрокиФайла = НомерСтрокиФайла;
		// Заполним данные контрагента.
		ЗаполнитьЗначенияСвойств(СтрокаДанныхЗаполнения, ДанныеКонтрагента);
		// Заполним данные по товрной категории и количествам.
		СтрокаДанныхЗаполнения.ТоварнаяКатегорияКодНСИ = ТоварнаяКатегорияКодНСИ;
		СтрокаДанныхЗаполнения.ТоварнаяКатегорияНаименование = ТоварнаяКатегорияНаименование;
		СтрокаДанныхЗаполнения.Количество = Подтверждено;
		СтрокаДанныхЗаполнения.КоличествоПервичное = Заказано;
	КонецЦикла; // Цикл по данным строки товарной категории.
	
КонецПроцедуры

Процедура ЗаполнитьДанныеТоварныхКатегорий(ДанныеЗаполнения, МассивОшибок)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаКодовНСИТоварныхКатегорий = ДанныеЗаполнения.Скопировать( , "ТоварнаяКатегорияКодНСИ");
	ТаблицаКодовНСИТоварныхКатегорий.Свернуть("ТоварнаяКатегорияКодНСИ");
	МассивКодовНСИТоварныхКатегорий = ТаблицаКодовНСИТоварныхКатегорий.ВыгрузитьКолонку("ТоварнаяКатегорияКодНСИ");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивКодовНСИТоварныхКатегорий", МассивКодовНСИТоварныхКатегорий);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварныеКатегории.Ссылка КАК ТоварнаяКатегория,
	|	ТоварныеКатегории.бг_КодНСИ КАК ТоварнаяКатегорияКодНСИ,
	|	ТоварныеКатегории.Наименование КАК ТоварнаяКатегорияНаименование,
	|	ТоварныеКатегории.бг_КатегорияВладельца КАК КатегорияВладельца,
	|	ТоварныеКатегории.бг_Бренд КАК Бренд
	|ПОМЕСТИТЬ СписокТоварныхКатегорий
	|ИЗ
	|	Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|ГДЕ
	|	НЕ ТоварныеКатегории.ПометкаУдаления
	|	И ТоварныеКатегории.бг_КодНСИ В(&МассивКодовНСИТоварныхКатегорий)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТоварнаяКатегорияКодНСИ,
	|	ТоварнаяКатегория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокТоварныхКатегорий.ТоварнаяКатегорияКодНСИ КАК ТоварнаяКатегорияКодНСИ,
	|	СписокТоварныхКатегорий.ТоварнаяКатегория КАК ТоварнаяКатегория,
	|	СписокТоварныхКатегорий.ТоварнаяКатегорияНаименование КАК ТоварнаяКатегорияНаименование,
	|	СписокТоварныхКатегорий.КатегорияВладельца КАК КатегорияВладельца,
	|	СписокТоварныхКатегорий.Бренд КАК Бренд
	|ИЗ
	|	СписокТоварныхКатегорий КАК СписокТоварныхКатегорий
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТоварныеКатегории КАК ДублиТоварныхКатегорий
	|		ПО СписокТоварныхКатегорий.ТоварнаяКатегорияКодНСИ = ДублиТоварныхКатегорий.бг_КодНСИ
	|			И СписокТоварныхКатегорий.ТоварнаяКатегория <> ДублиТоварныхКатегорий.Ссылка
	|			И НЕ ДублиТоварныхКатегорий.ПометкаУдаления
	|ГДЕ
	|	ДублиТоварныхКатегорий.Ссылка ЕСТЬ NULL";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ОтборСтрок = Новый Структура("ТоварнаяКатегорияКодНСИ");
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка.ТоварнаяКатегорияКодНСИ) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОтборСтрок, Выборка);
		НайденныеСтрокиДанныхЗаполнения = ДанныеЗаполнения.НайтиСтроки(ОтборСтрок);
		
		Для Каждого СтрокаДанныхЗаполнения Из НайденныеСтрокиДанныхЗаполнения Цикл
			ЗаполнитьЗначенияСвойств(СтрокаДанныхЗаполнения, Выборка);
		КонецЦикла;
		
	КонецЦикла;
	
	// Если не указан код НСИ, но указано наименование товарной категории, поищем по наименованию.
	ОтборСтрок = Новый Структура("ТоварнаяКатегория", Справочники.ТоварныеКатегории.ПустаяСсылка());
	НайденныеСтрокиДанныхЗаполнения = ДанныеЗаполнения.НайтиСтроки(ОтборСтрок);
	
	СтрокиУдалить = Новый Массив;
	Для Каждого СтрокаДанныхЗаполнения Из НайденныеСтрокиДанныхЗаполнения Цикл
		НомерСтрокиФайла = СтрокаДанныхЗаполнения.НомерСтрокиФайла;
		ТоварнаяКатегорияКодНСИ = СтрокаДанныхЗаполнения.ТоварнаяКатегорияКодНСИ; 
		ТоварнаяКатегорияНаименование = СтрокаДанныхЗаполнения.ТоварнаяКатегорияНаименование;
		
		Если ЗначениеЗаполнено(ТоварнаяКатегорияКодНСИ) Тогда
			ШаблонОшибки = НСтр(
				"ru = 'Данные строки %1 файла Excel не загружены, не найдена товарная категория по коду НСИ ""%2"".'");
			ТекстОшибки = СтрШаблон(ШаблонОшибки, НомерСтрокиФайла, ТоварнаяКатегорияКодНСИ);
			МассивОшибок.Добавить(ТекстОшибки);
			СтрокиУдалить.Добавить(СтрокаДанныхЗаполнения);
			Продолжить;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ТоварнаяКатегорияНаименование) Тогда
			СтруктураДанныхТоварнойКатегории = СтруктураДанныхТоварнойКатегорииПоНаименованию(
				ТоварнаяКатегорияНаименование);
			Если СтруктураДанныхТоварнойКатегории = Неопределено  Тогда
				СтрокиУдалить.Добавить(СтрокаДанныхЗаполнения);
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокаДанныхЗаполнения, СтруктураДанныхТоварнойКатегории);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаДанныхЗаполнения Из СтрокиУдалить Цикл
		ДанныеЗаполнения.Удалить(СтрокаДанныхЗаполнения);
	КонецЦикла;
	
КонецПроцедуры

Функция СтруктураДанныхТоварнойКатегорииПоНаименованию(Наименование)
	
	СтруктураДанных = Неопределено;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Возврат СтруктураДанных;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураДанных = Новый Структура(
		"ТоварнаяКатегория,
		|ТоварнаяКатегорияКодНСИ,
		|ТоварнаяКатегорияНаименование,
		|КатегорияВладельца");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ТоварныеКатегории.Ссылка КАК ТоварнаяКатегория,
	|	ТоварныеКатегории.бг_КодНСИ КАК ТоварнаяКатегорияКодНСИ,
	|	ТоварныеКатегории.Наименование КАК ТоварнаяКатегорияНаименование,
	|	ТоварныеКатегории.бг_КатегорияВладельца КАК КатегорияВладельца,
	|	ТоварныеКатегории.бг_Бренд КАК Бренд
	|ИЗ
	|	Справочник.ТоварныеКатегории КАК ТоварныеКатегории
	|ГДЕ
	|	НЕ ТоварныеКатегории.ПометкаУдаления
	|	И ТоварныеКатегории.Наименование = &Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			СтруктураДанных = Новый Структура(
				"ТоварнаяКатегория,
				|ТоварнаяКатегорияКодНСИ,
				|ТоварнаяКатегорияНаименование,
				|КатегорияВладельца,
				|Бренд");
			ЗаполнитьЗначенияСвойств(СтруктураДанных, Выборка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

Процедура ВывестиСообщенияОбОшибках(МассивОшибок)
	
	Для Каждого ТекстОшибки Из МассивОшибок Цикл
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЦикла;
	
КонецПроцедуры

Функция ЧислоИзСтроки(Знач ЗначениеСтрокой, Отказ)
	
	Результат = 0;
	
	Если ПустаяСтрока(ЗначениеСтрокой) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		ЗначениеСтрокой = СтрЗаменить(ЗначениеСтрокой, " ", "");
		ЗначениеСтрокой = СтрЗаменить(ЗначениеСтрокой, Символы.НПП, "");
		Результат = Число(ЗначениеСтрокой);
	Исключение
		Отказ = Истина;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти 

#КонецЕсли
