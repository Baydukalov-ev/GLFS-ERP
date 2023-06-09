
#Область ПрограммныйИнтерфейс

// Формирует xml файл с данными по отгрузке готовой продукции и помещает во временное хранилище.
// Параметры:
//	Документ - ДокументСсылка.ТТНИсходящаяЕГАИС, ДокументСсылка.РеализацияТоваровУслуг - документ на основании
//		которого, формируется пакет.
//	Отказ - Булево - признак отказа в формировании пакета.
//	СписокСообщений - Неопределено, СписокЗначений -список ошибок при формировании пакета. 
// Возвращаемое значение:
//	Структура:
//		*ИмяФайла - Строка - имя файла для отправки.
//		*Размер - Число - размер файла.
//		*Адрес - Строка - адрес двоичных данных во временнном хранилище.
//
Функция ОписаниеПакета(Документ, Отказ = Ложь, СписокСообщений = Неопределено) Экспорт

	Если СписокСообщений = Неопределено Тогда
		СписокСообщений = Новый СписокЗначений();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		ТТНИсходящая = ТТНИсходящаяПоРеализации(Документ);
	Иначе
		ТТНИсходящая = Документ;
	КонецЕсли;
	
	ОбъектXDTO = СформироватьОбъектXDTO(ТТНИсходящая, Отказ, СписокСообщений);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектXDTO, "ПакетЭОД");
	ЗаписьXML.Закрыть();
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяВременногоФайла);

	ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
	
	ОписаниеПакета = Новый Структура;
	ОписаниеПакета.Вставить("ИмяФайла", ИмяФайлаПакетаОтгрузкиГотовойПродукции(ТТНИсходящая));
	ОписаниеПакета.Вставить("Размер", ДвоичныеДанныеФайла.Размер());
	ОписаниеПакета.Вставить("Адрес",
		ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, Новый УникальныйИдентификатор));
	
	Возврат ОписаниеПакета;

КонецФункции

// Проверяет возможность сформировать пакет.
// Параметры:
//	Реализация - ДокументСсылка.РеализацияТоваровУслуг - ссылка на документ.
// Возвращаемое значение:
//	Булево - признак возможности сформировать пакет.
//
Функция ЕстьВозможностьСформироватьПакет(Реализация) Экспорт
	
	Возврат ЗначениеЗаполнено(ТТНИсходящаяПоРеализации(Реализация));
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает документ "ТТН исходящая ЕГАИС", который введен на основании документа "Реализация товаров и услуг".
// Параметры:
//	Реализация - ДокументСсылка.РеализацияТоваровУслуг - документ, для которого надо получить ТТН исходящую ЕГАИС.
// Возвращаемое значение:
//	ДокументСсылка.ТТНИсходящаяЕГАИС
//
Функция ТТНИсходящаяПоРеализации(Реализация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеквизитыТТН.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|ГДЕ
	|	РеквизитыТТН.ДокументОснование = &Реализация
	|	И НЕ РеквизитыТТН.бг_НомерФиксацииЕГАИС = """"";
	
	Запрос.УстановитьПараметр("Реализация", Реализация);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Документы.ТТНИсходящаяЕГАИС.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяФайлаПакетаОтгрузкиГотовойПродукции(ТТНИсходящая)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеквизитыТТН.Номер КАК Номер,
	|	РеквизитыТТН.Дата КАК Дата,
	|	РеквизитыОрганизации.бг_Тикер КАК КодОрганизации
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеквизитыРТУ
	|		ПО РеквизитыТТН.ДокументОснование = РеквизитыРТУ.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК РеквизитыОрганизации
	|		ПО РеквизитыРТУ.Организация = РеквизитыОрганизации.Ссылка
	|ГДЕ
	|	РеквизитыТТН.Ссылка = &ТТНИсходящая";
	
	Запрос.УстановитьПараметр("ТТНИсходящая", ТТНИсходящая);
	РеквизитыДокументов = Запрос.Выполнить().Выбрать();
	
	НомерТТН = СтрЗаменить(СтрЗаменить(СокрЛП(РеквизитыДокументов.Номер), "/", ""), "\", "");
	КодОрганизации = СокрЛП(РеквизитыДокументов.КодОрганизации);
	Префикс = "TTNBG";
	
	Возврат СтрШаблон(
			НСтр("ru = '%1_%2_%3_%4_%5.xml'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Префикс, КодОрганизации, НомерТТН, Формат(РеквизитыДокументов.Дата, "ДФ=yyyyMMdd"),
			Формат(ТекущаяДатаСеанса(), "ДФ=yyyyMMdd_HHmmss"));
	
КонецФункции

Функция СформироватьОбъектXDTO(Объект, Отказ, СписокСообщений)
	
	ПространствоИмен = "http://www.sygroup.ru/DocExchange/";
	ТипОбъектаXDTO_Document = ФабрикаXDTO.Тип(ПространствоИмен, "Document");
	ОбъектXDTO_Document = ФабрикаXDTO.Создать(ТипОбъектаXDTO_Document);
 	
	СтруктураШапки = ПолучитьСтруктуруШапкиДокумента(Объект, Отказ, СписокСообщений);
	ЗаполнитьЭлементXDTOПоСтруктуре(ОбъектXDTO_Document, СтруктураШапки);
	
	ОбъектXDTO_Products = СформироватьБлок_Products(ПространствоИмен, Объект, Отказ, СписокСообщений);
	ОбъектXDTO_Document.Products = ОбъектXDTO_Products;
	
	ОбъектXDTO_SerialNumbers = СформироватьБлок_SerialNumbers(ПространствоИмен, Объект, Отказ, СписокСообщений);
	ОбъектXDTO_Document.SerialNumbers = ОбъектXDTO_SerialNumbers;
	
	ОбъектXDTO_ConformityDeclarations = СформироватьБлок_ConformityDeclarations(
		ПространствоИмен, Объект, Отказ, СписокСообщений);
	ОбъектXDTO_Document.ConformityDeclarations = ОбъектXDTO_ConformityDeclarations;
	
	ОбъектXDTO_Content = СформироватьБлок_Content(ПространствоИмен, Объект, Отказ, СписокСообщений);
	ОбъектXDTO_Document.Content = ОбъектXDTO_Content;
	
	ОбъектXDTO_Sets = СформироватьБлок_Sets(ПространствоИмен, Объект, Отказ, СписокСообщений);
	ОбъектXDTO_Document.Sets = ОбъектXDTO_Sets;
	
	Возврат ОбъектXDTO_Document;
	
КонецФункции

Функция ПолучитьСтруктуруШапкиДокумента(Ссылка, Отказ, СписокСообщений) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеквизитыОрганизации.бг_Тикер КАК SenderTiker,
	|	РеквизитыРТУ.Номер КАК Number,
	|	РеквизитыРТУ.Дата КАК Date,
	|	РеквизитыКонтрагента.бг_Тикер КАК RecipientTiker,
	|	РеквизитыГрузоотправителя.Код КАК IdLoadPoint,
	|	РеквизитыГрузополучателя.Код КАК IdUnloadPoint,
	|	РеквизитыТТН.ИдентификаторЕГАИС КАК IdTTN_EGAIS,
	|	ЕСТЬNULL(РеквизитыСообщения.ИдентификаторЗапроса, """") КАК IdTransportPackage,
	|	ЕСТЬNULL(РеквизитыЗаказа.НомерПоДаннымКлиента, """") КАК OrderNumber,
	|	ЕСТЬNULL(РеквизитыЗаказа.ДатаПоДаннымКлиента, ДАТАВРЕМЯ(1, 1, 1)) КАК OrderDate
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеквизитыРТУ
	|		ПО РеквизитыРТУ.Ссылка = РеквизитыТТН.ДокументОснование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК РеквизитыКонтрагента
	|		ПО РеквизитыРТУ.Контрагент = РеквизитыКонтрагента.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК РеквизитыОрганизации
	|		ПО РеквизитыРТУ.Организация = РеквизитыОрганизации.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК РеквизитыГрузоотправителя
	|		ПО РеквизитыТТН.Грузоотправитель = РеквизитыГрузоотправителя.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК РеквизитыГрузополучателя
	|		ПО РеквизитыТТН.Грузополучатель = РеквизитыГрузополучателя.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК РеквизитыСообщения
	|		ПО РеквизитыТТН.Ссылка = РеквизитыСообщения.Документ
	|			И РеквизитыСообщения.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.ТТН)
	|			И РеквизитыСообщения.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийЕГАИС.КПередаче)
	|			И РеквизитыСообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК РеквизитыЗаказа
	|		ПО РеквизитыРТУ.ЗаказКлиента = РеквизитыЗаказа.Ссылка
	|ГДЕ
	|	РеквизитыТТН.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	СтруктураШапкиДокумента = Новый Структура;
	СтруктураШапкиДокумента.Вставить("PackageVersion", "3");
	СтруктураШапкиДокумента.Вставить("DocumentType", "1");
	СтруктураШапкиДокумента.Вставить("UnloadDate", ТекущаяДата);
	СтруктураШапкиДокумента.Вставить("UnloadTime", Формат(ТекущаяДата, "ДЛФ=T"));
	
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		СтруктураШапкиДокумента.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
	КонецЦикла;
	
	ОбработатьДанныеПоПравилам(СтруктураШапкиДокумента,
		ПравилаЗаполненияПолейШапкиДокумента(), СписокСообщений, Отказ);
	
	Возврат СтруктураШапкиДокумента;
	
КонецФункции

Функция ПравилаЗаполненияПолейШапкиДокумента()
	
	Правила = Новый Структура;
	Правила.Вставить("IdLoadPoint",
		ОписаниеПравила(
			НСтр("ru = 'Не удалось получить организацию ЕГАИС для пункта разгрузки организации.'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Ложь, Истина));

	Правила.Вставить("IdUnloadPoint",
		ОписаниеПравила(
			НСтр("ru = 'Не удалось получить организацию ЕГАИС для пункта разгрузки контрагента.'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Ложь, Истина));
			
	Правила.Вставить("RecipientTiker",
		ОписаниеПравила(
			НСтр("ru = 'Не удалось получить тикер получателя для контрагента.'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Ложь, Истина));
	
	Правила.Вставить("OrderNumber", ОписаниеПравила("", Истина));
	Правила.Вставить("OrderDate", ОписаниеПравила("", Истина));
	
	Правила.Вставить("IdTTN_EGAIS",
		ОписаниеПравила(
			НСтр("ru = 'Не удалось получить ТТН ЕГАИС для документа.'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Ложь));
	
	Возврат Правила;
	
КонецФункции

Функция ОписаниеПравила(ТекстОшибки, УдалятьЕслиПустоеЗначение = Ложь, ОбязательноеПоле = Ложь)
	
	Возврат Новый Структура("ТекстОшибки, УдалятьЕслиПустоеЗначение, ОбязательноеПоле",
		ТекстОшибки, УдалятьЕслиПустоеЗначение, ОбязательноеПоле);
	
КонецФункции

Процедура ОбработатьДанныеПоПравилам(Данные, ПравилаЗаполнения, Ошибки, Отказ)
	
	Для Каждого Правило Из ПравилаЗаполнения Цикл
		
		ЕстьОшибка = Ложь;
		Если Не ЗначениеЗаполнено(Данные[Правило.Ключ]) Тогда
			
			ЕстьОшибка = Истина;
			Если ЗначениеЗаполнено(Правило.Значение.ТекстОшибки) Тогда
				Ошибки.Добавить(Правило.Значение.ТекстОшибки);
			КонецЕсли;
			
			Если Правило.Значение.УдалятьЕслиПустоеЗначение Тогда
				Данные.Удалить(Правило.Ключ);
			КонецЕсли;
			
		КонецЕсли;
		
		Отказ = Отказ Или ЕстьОшибка И Правило.Значение.ОбязательноеПоле;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьБлок_Products(ПространствоИмен, Ссылка, Отказ, СписокСообщений)
	
	ТипОбъектаXDTO_Products = ФабрикаXDTO.Тип(ПространствоИмен, "Products");
	ОбъектXDTO_Products = ФабрикаXDTO.Создать(ТипОбъектаXDTO_Products);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Серия КАК Серия,
	|	МАКСИМУМ(ЕСТЬNULL(НоменклатураКонтрагентов.Артикул, """")) КАК Код,
	|	МАКСИМУМ(ЕСТЬNULL(Штрихкоды.Штрихкод, """")) КАК Штрихкод
	|ПОМЕСТИТЬ КодыНоменклатуры
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ТаблицаТовары
	|		ПО ТаблицаТовары.Ссылка = РеквизитыТТН.ДокументОснование
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураКонтрагентовБЭД КАК НоменклатураКонтрагентов
	|		ПО ТаблицаТовары.Номенклатура = НоменклатураКонтрагентов.Номенклатура
	|			И НоменклатураКонтрагентов.Владелец = ТаблицаТовары.Ссылка.Партнер
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК РеквизитыСерии
	|		ПО ТаблицаТовары.Серия = РеквизитыСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыПаллетыСерии
	|		ПО РеквизитыСерии.бг_УпаковкаПаллета = РеквизитыПаллетыСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.бг_Штрихкоды_ЕК_Номенклатуры КАК Штрихкоды
	|		ПО РеквизитыПаллетыСерии.Родитель = Штрихкоды.Владелец
	|			И ТаблицаТовары.Номенклатура.ЕдиницаИзмерения = Штрихкоды.ЕдиницаИзмерения
	|ГДЕ
	|	РеквизитыТТН.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура, 
	|	РеквизитыНоменклатуры.ЕдиницаИзмерения КАК ЕдиницаИзмерения, 
	|	РеквизитыНоменклатуры.Код КАК ProductCode,
	|	РеквизитыНоменклатуры.Код КАК ProductID,
	|	РеквизитыНоменклатуры.Наименование КАК ProductName,
	|	РеквизитыЕдИзмНоменклатуры.Код КАК UnitOfMeasure,
	|	ЕСТЬNULL(РеквизитыНижестоящейУпаковки.КоличествоУпаковок, """") КАК UnitPackSize,
	|	ЕСТЬNULL(РеквизитыЕдИзмНижестоящейУпаковки.Код, """") КАК UnitOfPack,
	|	ЕСТЬNULL(РеквизитыПаллеты.бг_КодЕК_Номенклатуры, """") КАК CodeEK, 
	|	ЕСТЬNULL(РеквизитыТоварнойКатегорииНоменклатуры.бг_КодНСИ, """") КАК CodeEK_SKU,
	|	ЕСТЬNULL(КодыНоменклатуры.Штрихкод, """") КАК BarCode,
	|	ЕСТЬNULL(КодыНоменклатуры.Код, """") КАК BuyerProductCode
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ТаблицаТовары
	|		ПО ТаблицаТовары.Ссылка = РеквизитыТТН.ДокументОснование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК РеквизитыНоменклатуры
	|		ПО ТаблицаТовары.Номенклатура = РеквизитыНоменклатуры.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыЕдИзмНоменклатуры
	|		ПО РеквизитыНоменклатуры.ЕдиницаИзмерения = РеквизитыЕдИзмНоменклатуры.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК РеквизитыСерии
	|		ПО ТаблицаТовары.Серия = РеквизитыСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТоварныеКатегории КАК РеквизитыТоварнойКатегорииНоменклатуры
	|		ПО РеквизитыНоменклатуры.ТоварнаяКатегория = РеквизитыТоварнойКатегорииНоменклатуры.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыПаллеты
	|		ПО РеквизитыСерии.бг_УпаковкаПаллета = РеквизитыПаллеты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыНижестоящейУпаковки
	|		ПО РеквизитыПаллеты.Родитель = РеквизитыНижестоящейУпаковки.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыЕдИзмНижестоящейУпаковки
	|		ПО РеквизитыНижестоящейУпаковки.ЕдиницаИзмерения = РеквизитыЕдИзмНижестоящейУпаковки.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ КодыНоменклатуры КАК КодыНоменклатуры
	|		ПО ТаблицаТовары.Номенклатура = КодыНоменклатуры.Номенклатура
	|			И ТаблицаТовары.Серия = КодыНоменклатуры.Серия
	|ГДЕ
	|	РеквизитыТТН.Ссылка = &Ссылка";
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать(); 
	
	ПравилаЗаполненияПолей = ПравилаЗаполненияПолейProduct();
	Пока Выборка.Следующий() Цикл

		СтруктураProduct = Новый Структура;
		ТипОбъектаXDTO_Product = ФабрикаXDTO.Тип(ПространствоИмен, "Product");
		ОбъектXDTO_Product = ФабрикаXDTO.Создать(ТипОбъектаXDTO_Product);
		
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			СтруктураProduct.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
		КонецЦикла;
		
		ОбработатьДанныеПоПравилам(СтруктураProduct, ПравилаЗаполненияПолей, СписокСообщений, Отказ);
		
		ЗаполнитьЭлементXDTOПоСтруктуре(ОбъектXDTO_Product, СтруктураProduct);
		ОбъектXDTO_Products.Product.Добавить(ОбъектXDTO_Product);
		
	КонецЦикла;
	
	Возврат ОбъектXDTO_Products;
	
КонецФункции

Функция ПравилаЗаполненияПолейProduct()
	
	Правила = Новый Структура;
	Правила.Вставить("BarCode", ОписаниеПравила("", Истина));
	
	Возврат Правила;
	
КонецФункции

Функция СформироватьБлок_SerialNumbers(ПространствоИмен, Ссылка, Отказ, СписокСообщений)

	ТипОбъектаXDTO_SerialNumbers = ФабрикаXDTO.Тип(ПространствоИмен, "SerialNumbers");
	ОбъектXDTO_SerialNumbers = ФабрикаXDTO.Создать(ТипОбъектаXDTO_SerialNumbers);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РеквизитыНоменклатуры.Наименование КАК НаименованиеНоменклатуры,
	|	ЕСТЬNULL(РеквизитыПродукцииЕГАИС.Код, """") КАК EGAIS_ProductCode,
	|	ЕСТЬNULL(РеквизитыВидаПродукцииЕГАИС.Код, """") КАК AlcoholTypeCode,
	|	ТаблицаТоварыЕГАИС.Серия КАК СерияНоменклатуры,
	|	РеквизитыСерии.Номер КАК SN_ID,
	|	РеквизитыСерии.Номер КАК SN_Code,
	|	РеквизитыСерии.Наименование КАК SN_Name,
	|	РеквизитыСерии.ДатаПроизводства КАК ProductionDate,
	|	ЕСТЬNULL(РеквизитыОрганизацийЕГАИС.КодСтраны, """") КАК OriginCountry,
	|	ЕСТЬNULL(РеквизитыОрганизацийЕГАИС.Код, """") КАК IDProducer,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(РеквизитыСтран.УчастникЕАЭС, ИСТИНА)
	|			ТОГДА ЕСТЬNULL(РеквизитыИмпортера.Код, """")
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК IDImporter,
	|	ВЫБОР
	|		КОГДА НЕ ЕСТЬNULL(РеквизитыСтран.УчастникЕАЭС, ИСТИНА)
	|			ТОГДА ЕСТЬNULL(РеквизитыИмпортера.Код, """")
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК IDPoint_P_I,
	|	ЕСТЬNULL(РеквизитыСертификатаСерии.Номер, """") КАК ConformityDeclaration_ID,
	|	ЕСТЬNULL(РеквизитыСправки2Серии.бг_ДатаНачисленияАкциза, ДАТАВРЕМЯ(1, 1, 1)) КАК DateAccrualExciseDuty,
	|	ЕСТЬNULL(РеквизитыСправки2Товары.РегистрационныйНомер, """") КАК InformB,
	|	ЕСТЬNULL(РеквизитыСправки1Товары.РегистрационныйНомер, """") КАК InformA,
	|	ЕСТЬNULL(РеквизитыГТДСправки1Товары.Код, """") КАК CustomsDeclaration,
	|	ТаблицаТоварыЕГАИС.НомерСправки2Покупателя КАК BuyerInformB,
	|	"""" КАК ProductComposition
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТаблицаТоварыЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК РеквизитыНоменклатуры
	|		ПО ТаблицаТоварыЕГАИС.Номенклатура = РеквизитыНоменклатуры.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК РеквизитыСерии
	|		ПО ТаблицаТоварыЕГАИС.Серия = РеквизитыСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК РеквизитыСправки2Серии
	|		ПО РеквизитыСерии.Справка2ЕГАИС = РеквизитыСправки2Серии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки1ЕГАИС КАК РеквизитыСправки1Серии
	|		ПО РеквизитыСправки2Серии.Справка1 = РеквизитыСправки1Серии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК РеквизитыИмпортера
	|		ПО РеквизитыСправки1Серии.Грузоотправитель = РеквизитыИмпортера.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СертификатыНоменклатуры КАК РеквизитыСертификатаСерии
	|		ПО РеквизитыСерии.бг_Сертификат = РеквизитыСертификатаСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК РеквизитыСправки2Товары
	|		ПО ТаблицаТоварыЕГАИС.Справка2 = РеквизитыСправки2Товары.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки1ЕГАИС КАК РеквизитыСправки1Товары
	|		ПО РеквизитыСправки2Товары.Справка1 = РеквизитыСправки1Товары.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НомераГТД КАК РеквизитыГТДСправки1Товары
	|		ПО РеквизитыСправки1Товары.бг_НомерГТД = РеквизитыГТДСправки1Товары.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК РеквизитыОрганизацийЕГАИС
	|		ПО РеквизитыСерии.ПроизводительЕГАИС = РеквизитыОрганизацийЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК РеквизитыСтран
	|		ПО РеквизитыОрганизацийЕГАИС.КодСтраны = РеквизитыСтран.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК РеквизитыПродукцииЕГАИС
	|		ПО ТаблицаТоварыЕГАИС.АлкогольнаяПродукция = РеквизитыПродукцииЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК РеквизитыВидаПродукцииЕГАИС
	|		ПО РеквизитыПродукцииЕГАИС.ВидПродукции = РеквизитыВидаПродукцииЕГАИС.Ссылка
	|ГДЕ
	|	ТаблицаТоварыЕГАИС.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(); 
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураSerialNumber = Новый Структура;
		ТипОбъектаXDTO_SerialNumber = ФабрикаXDTO.Тип(ПространствоИмен, "SerialNumber");
		ОбъектXDTO_SerialNumber = ФабрикаXDTO.Создать(ТипОбъектаXDTO_SerialNumber);
		Для Каждого Колонка Из Результат.Колонки Цикл
			СтруктураSerialNumber.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);		
		КонецЦикла;
		
		ОбработатьДанныеПоПравилам(СтруктураSerialNumber,
			ПравилаЗаполненияПолейSerialNumbers(Выборка.НаименованиеНоменклатуры, Выборка.SN_Name, Выборка.SN_ID),
			СписокСообщений, Отказ);
		
		ЗаполнитьЭлементXDTOПоСтруктуре(ОбъектXDTO_SerialNumber, СтруктураSerialNumber);

		ОбъектXDTO_SerialNumber.StripStampInfo = ФабрикаXDTO.Создать(
			ФабрикаXDTO.Тип(ПространствоИмен, "StripStampInfo"));
		ОбъектXDTO_SerialNumbers.SerialNumber.Добавить(ОбъектXDTO_SerialNumber);
		
	КонецЦикла;
	
	Возврат ОбъектXDTO_SerialNumbers;
	
КонецФункции

Функция ПравилаЗаполненияПолейSerialNumbers(НаименованиеНоменклатуры, НаименованиеСерии, НомерСерии)
	
	Правила = Новый Структура;

	ШаблонОшибки = СтрШаблон(
		НСтр("ru = 'Не удалось получить справку Б исходящую для номенклатуры: %1, Серия: %2.'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		НаименованиеНоменклатуры, НаименованиеСерии);
	Правила.Вставить("BuyerInformB", ОписаниеПравила(ШаблонОшибки, Истина));

	ШаблонОшибки = СтрШаблон(
		НСтр("ru = 'Не удалось найти алкогольную продукцию для серии: %1, Серия: %2.'",
			ОбщегоНазначения.КодОсновногоЯзыка()),
		НаименованиеСерии, НомерСерии);
	Правила.Вставить("EGAIS_ProductCode", ОписаниеПравила(ШаблонОшибки, Истина));
	Правила.Вставить("AlcoholTypeCode", ОписаниеПравила("", Истина));
	Правила.Вставить("IDProducer", ОписаниеПравила("", Истина));
	Правила.Вставить("IDImporter", ОписаниеПравила("", Истина));
	Правила.Вставить("IDPoint_P_I", ОписаниеПравила("", Истина));
	
	Возврат Правила;
	
КонецФункции

Функция СформироватьБлок_ConformityDeclarations(ПространствоИмен, Ссылка, Отказ, СписокСообщений)
	
	ТипОбъектаXDTO_ConformityDeclarations = ФабрикаXDTO.Тип(ПространствоИмен, "ConformityDeclarations");
	ОбъектXDTO_ConformityDeclarations = ФабрикаXDTO.Создать(ТипОбъектаXDTO_ConformityDeclarations);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(КлассификаторОрганизаций.Код, """") КАК CD_Owner,
	|	РеквизитыСертификата.Номер КАК CD_ID,
	|	РеквизитыСертификата.Наименование КАК CD_Name,
	|	РеквизитыСертификата.Номер КАК CD_Number,
	|	РеквизитыСертификата.ДатаНачалаСрокаДействия КАК CD_IssueDate,
	|	РеквизитыСертификата.ДатаОкончанияСрокаДействия КАК CD_ValidityPeriod,
	|	РеквизитыСертификата.ОрганВыдавшийДокумент КАК CD_IssuingAuthority,
	|	РеквизитыСертификата.ТипСертификата КАК CD_NormativeDocument,
	|	"""" КАК CD_NumberLaboratoryTestProtocol
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТаблицаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СертификатыНоменклатуры КАК РеквизитыСертификата
	|		ПО ТаблицаТовары.Серия.бг_Сертификат = РеквизитыСертификата.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизаций
	|		ПО КлассификаторОрганизаций.Контрагент = РеквизитыСертификата.бг_ВладелецСертификата
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	ПравилаЗаполненияПолей = ПравилаЗаполненияПолейConformityDeclarations();
	Пока Выборка.Следующий() Цикл
		
		ТипОбъектаXDTO_ConformityDeclaration = ФабрикаXDTO.Тип(ПространствоИмен, "ConformityDeclaration");
		ОбъектXDTO_ConformityDeclaration = ФабрикаXDTO.Создать(ТипОбъектаXDTO_ConformityDeclaration);
		
		СтруктураConformityDeclaration = Новый Структура;
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			СтруктураConformityDeclaration.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
		КонецЦикла;
		
		ОбработатьДанныеПоПравилам(СтруктураConformityDeclaration, ПравилаЗаполненияПолей, СписокСообщений, Отказ);
		
		ЗаполнитьЭлементXDTOПоСтруктуре(ОбъектXDTO_ConformityDeclaration, СтруктураConformityDeclaration); 
		ОбъектXDTO_ConformityDeclarations.ConformityDeclaration.Добавить(ОбъектXDTO_ConformityDeclaration);
		
	КонецЦикла;
	
	Возврат ОбъектXDTO_ConformityDeclarations;
	
КонецФункции

Функция ПравилаЗаполненияПолейConformityDeclarations()
	
	Правила = Новый Структура;
	Правила.Вставить("CD_Owner", ОписаниеПравила("", Истина));
	
	Возврат Правила;
	
КонецФункции

Функция СформироватьБлок_Content(ПространствоИмен, Ссылка, Отказ, СписокСообщений)
	
	ТипОбъектаXDTO_Content = ФабрикаXDTO.Тип(ПространствоИмен, "Content");
	ОбъектXDTO_Content = ФабрикаXDTO.Создать(ТипОбъектаXDTO_Content);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.НомерСтроки КАК LineNumber,
	|	ТаблицаТовары.Номенклатура.Код КАК ProductID,
	|	ТаблицаТовары.Серия.Номер КАК SN_ID,
	|	ТаблицаТовары.КоличествоУпаковок КАК Quantity,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РеквизитыНижестоящейУпаковки.КоличествоУпаковок, 0) = 0
	|			ТОГДА 1
	|		ИНАЧЕ ТаблицаТовары.КоличествоУпаковок / РеквизитыНижестоящейУпаковки.КоличествоУпаковок
	|	КОНЕЦ КАК QuantityOfPacks,
	|	ТаблицаТовары.Цена КАК Price,
	|	ЕСТЬNULL(ТаблицаТовары.СтавкаНДС.Ставка, 0) КАК VATRate,
	|	ТаблицаТовары.Сумма КАК Amount,
	|	ТаблицаТовары.СуммаНДС КАК VATAmount,
	|	ТаблицаТовары.СуммаАвтоматическойСкидки КАК AutomaticDiscountAmount,
	|	ТаблицаТовары.СуммаРучнойСкидки КАК ManualDiscountAmount,
	|	ТаблицаТовары.Цена * ТаблицаТовары.КоличествоУпаковок КАК AmountWithoutDiscount,
	|	ТаблицаТовары.ПроцентАвтоматическойСкидки КАК AutomaticDiscountsPercent,
	|	ТаблицаТовары.ПроцентРучнойСкидки КАК ManualDiscountsPercent
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК РеквизитыТТН
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ТаблицаТовары
	|		ПО ТаблицаТовары.Ссылка = РеквизитыТТН.ДокументОснование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК РеквизитыСерии
	|		ПО ТаблицаТовары.Серия = РеквизитыСерии.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыПаллеты
	|		ПО РеквизитыСерии.бг_УпаковкаПаллета = РеквизитыПаллеты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК РеквизитыНижестоящейУпаковки
	|		ПО РеквизитыПаллеты.Родитель = РеквизитыНижестоящейУпаковки.Ссылка
	|ГДЕ
	|	РеквизитыТТН.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл

		СтруктураLine = Новый Структура;
		ТипОбъектаXDTO_Line = ФабрикаXDTO.Тип(ПространствоИмен, "Line");
		ОбъектXDTO_Line = ФабрикаXDTO.Создать(ТипОбъектаXDTO_Line);
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			СтруктураLine.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
		КонецЦикла;
		ЗаполнитьЭлементXDTOПоСтруктуре(ОбъектXDTO_Line, СтруктураLine);
		ОбъектXDTO_Content.Line.Добавить(ОбъектXDTO_Line);
		
	КонецЦикла;
	
	Возврат ОбъектXDTO_Content;
	
КонецФункции

Функция СформироватьБлок_Sets(ПространствоИмен, Ссылка, Отказ, СписокСообщений)
	
	Возврат ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "Sets"));
	
КонецФункции

Процедура ЗаполнитьЭлементXDTOПоСтруктуре(ЭлементXDTO, Структура)
	
	Для Каждого СвойствоXDTO Из ЭлементXDTO.Свойства() Цикл
		
		Если Не Структура.Свойство(СвойствоXDTO.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Структура[СвойствоXDTO.Имя] = Null Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			
			Если ТипЗнч(Структура[СвойствоXDTO.Имя]) = Тип("Строка") Тогда
				Структура[СвойствоXDTO.Имя] = СокрЛП(Структура[СвойствоXDTO.Имя]);
			КонецЕсли;
			ЭлементXDTO[СвойствоXDTO.Имя] = Структура[СвойствоXDTO.Имя];
			
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Формирование пакета отгрузки готовой продукции'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
