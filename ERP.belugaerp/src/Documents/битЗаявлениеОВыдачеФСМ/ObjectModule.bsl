
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&Вместо("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	
	Идентификатор           = "";
	ИдентификаторЕГАИС      = "";
	
КонецПроцедуры

&Вместо("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = Новый УникальныйИдентификатор();
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

&Вместо("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

&Вместо("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроверитьУникальностьНоменклатуры(Отказ);
	ПроверитьВидАлкогольнойПродукции(Отказ);
	ПроверитьУникальностьВидаМаркиТипаАлкогольнойПродукции(Отказ)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУникальностьНоменклатуры(Отказ)
	
	СтрокиНоменклатуры = Новый Соответствие;
	Дубли = Новый Массив;
	Для Каждого Товар Из Товары Цикл
		Если СтрокиНоменклатуры[Товар.Номенклатура] = Неопределено Тогда
			СтрокиНоменклатуры.Вставить(Товар.Номенклатура, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Товар.НомерСтроки));
		Иначе
			Дубли.Добавить(Товар.Номенклатура);
			СтрокиНоменклатуры[Товар.Номенклатура].Добавить(Товар.НомерСтроки)
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Дубль Из Дубли Цикл
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = '%1 указан в нескольких строках:
				           |%2
				           |Введите эту номенклатуру одной строкой.'"),
				Дубль,
				СтрСоединить(СтрокиНоменклатуры[Дубль], ", ")),
			ЭтотОбъект,
			"Товары",,        
			Отказ);
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ПроверитьВидАлкогольнойПродукции(Отказ)
	
	ВидАлкогольнойПродукцииНомеклатуры = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
			Товары.ВыгрузитьКолонку("Номенклатура"), 
			"ВидАлкогольнойПродукции");
			
	Ошибки = Новый Массив;
	Для Каждого Товар Из Товары Цикл
		Если ВидАлкогольнойПродукцииНомеклатуры[Товар.Номенклатура] <> ВидАлкогольнойПродукции Тогда
			Ошибки.Добавить(Товар.НомерСтроки);
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Ошибка Из Ошибки Цикл
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru = 'В строке %1 вид алгокольной продукции (%2) отличается от указанной в документе (%3)'"),
				Ошибка,
				ВидАлкогольнойПродукцииНомеклатуры[Товары[Ошибка-1].Номенклатура],
				ВидАлкогольнойПродукции),
			ЭтотОбъект,
			"Товары",,        
			Отказ);
	КонецЦикла;	
	
КонецПроцедуры	
	
Процедура ПроверитьУникальностьВидаМаркиТипаАлкогольнойПродукции(Отказ)
	
	Номенклатура = Товары.Выгрузить(, "Номенклатура");
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Товары.Выгрузить(, "Номенклатура"));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.бг_ТипМарки КАК ТипМарки,
	|	Номенклатура.ВидАлкогольнойПродукции КАК ВидАлкогольнойПродукции
	|ПОМЕСТИТЬ ВТНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&Номенклатура)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипМарки,
	|	ВидАлкогольнойПродукции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Номенклатура.ТипМарки КАК ТипМарки,
	|	Номенклатура.ВидАлкогольнойПродукции КАК ВидАлкогольнойПродукции
	|ПОМЕСТИТЬ ВТДубли
	|ИЗ
	|	ВТНоменклатура КАК Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.ТипМарки,
	|	Номенклатура.ВидАлкогольнойПродукции
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) > 1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипМарки,
	|	ВидАлкогольнойПродукции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Дубли.ТипМарки КАК ТипМарки,
	|	Дубли.ВидАлкогольнойПродукции КАК ВидАлкогольнойПродукции,
	|	ПРЕДСТАВЛЕНИЕ(Дубли.ТипМарки) КАК ПредставлениеМарки,
	|	ПРЕДСТАВЛЕНИЕ(Дубли.ВидАлкогольнойПродукции) КАК ПредставлениеВидаПродукции,
	|	Номенклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	ВТДубли КАК Дубли
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНоменклатура КАК Номенклатура
	|		ПО Дубли.ТипМарки = Номенклатура.ТипМарки
	|			И Дубли.ВидАлкогольнойПродукции = Номенклатура.ВидАлкогольнойПродукции
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дубли.ТипМарки.Представление,
	|	Дубли.ВидАлкогольнойПродукции.Представление";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиНоменклатуры = Товары.Выгрузить(, "Номенклатура, НомерСтроки");
	СтрокиНоменклатуры.Индексы.Добавить("Номенклатура");
	ПоискНоменклатуры = Новый Структура("Номенклатура");
	
	Повторы = Новый Массив;
	СтрокиДублей = Новый ТаблицаЗначений;
	СтрокиДублей.Колонки.Добавить("НомерСтроки");
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("ТипМарки") Цикл
		ПредставлениеТипаМарки     = Выборка.ПредставлениеМарки;
		Пока Выборка.СледующийПоЗначениюПоля("ВидАлкогольнойПродукции") Цикл
			ПредставлениеВидаПродукции = Выборка.ПредставлениеВидаПродукции;
			Пока Выборка.Следующий() Цикл
				ПоискНоменклатуры.Номенклатура = Выборка.Номенклатура;
				Для Каждого СтрокаНоменклатуры Из СтрокиНоменклатуры.НайтиСтроки(ПоискНоменклатуры) Цикл
					ЗаполнитьЗначенияСвойств(СтрокиДублей.Добавить(), СтрокаНоменклатуры); 
				КонецЦикла;	
			КонецЦикла;	
			СтрокиДублей.Сортировать("НомерСтроки");
			Повторы.Добавить(
				СтрШаблон(
					"%1 и %2 в строках %3",
					ПредставлениеТипаМарки,
					ПредставлениеВидаПродукции,
					СтрСоединить(СтрокиДублей.ВыгрузитьКолонку("НомерСтроки"), ", ")));
			СтрокиДублей.Очистить();	
		КонецЦикла;	
	КонецЦикла;	
	
	ОбщегоНазначения.СообщитьПользователю(
		СтрШаблон(
			"Совпадают типы марок и виды алкогольной продукции:
			|%1
			|Оформите разными заявлениями.",
			СтрСоединить(Повторы, Символы.ПС)),
		ЭтотОбъект,
		"Товары",,        
		Отказ);
	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли