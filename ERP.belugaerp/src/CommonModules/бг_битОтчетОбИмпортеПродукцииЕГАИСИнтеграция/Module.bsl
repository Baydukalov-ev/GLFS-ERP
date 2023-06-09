#Область ПрограммныйИнтерфейс

#Область Переопределяемые

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена; // Используем модуль из расширения БИТMDT, обходим ошибки синтакс-проверки.
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	// Оставляем реквизиты объекта метаданных к выгрузке.
	ИменаВыгружаемыхРеквизитов = ИменаВыгружаемыхРеквизитов();
	
	адаптер_НастройкиОбмена.ОставитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ИменаВыгружаемыхРеквизитов);
	
	// Добавляем дополнительные поля к выгрузке.
	
	// ПунктРазгрузки: в ERP это склад или контрагент, в УПП - отдельный справочник алкПунктыРазгрузки.
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ПунктРазгрузкиИдентификатор",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(36)));	
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"СтатусДокумента",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(36)));	
		
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"Товары.АлкогольнаяПродукцияКод",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(50)));	

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"Товары.Справка1РегистрационныйНомер",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(50)));	

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"Товары.Справка2РегистрационныйНомер",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(50)));	

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ДокументОснованиеИдентификатор",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(36)));	

	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ИдентификаторЗапросаУТМ",
		Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(36)));	

КонецПроцедуры	
		
Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ПараметрыВыполненияЗапросов = адаптер_РаботаСДаннымиИБ.ПолучитьПараметрыВыполненияЗапросов(Объект, ДанныеСообщения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаВыгружаемыхДанных();
	Запрос.УстановитьПараметр("Ссылка", ПараметрыВыполненияЗапросов.ПараметрыЗапроса.Ссылка);
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	РезультатЗапросаШапка = РезультатыЗапросов[0];
	РезультатЗапросаТовары = РезультатыЗапросов[1];
	
	Реквизиты = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
		РезультатЗапросаШапка,
		ПараметрыВыполненияЗапросов.ТаблицаКлючей,
		ДанныеСообщения);
	
	Если Реквизиты.Количество() > 0 Тогда
		Товары = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(
			РезультатЗапросаТовары,
			ПараметрыВыполненияЗапросов.ТаблицаКлючей,
			ДанныеСообщения);
		
		Реквизиты[0].Вставить("Товары", Товары);	
		
		ЗаполнитьСтроковыйИдентификаторСвойства(Реквизиты, "ДокументОснованиеИдентификатор");	
		ЗаполнитьСтроковыйИдентификаторСвойства(Реквизиты, "ПунктРазгрузкиИдентификатор");	
		ЗаполнитьИдентификаторЗапросаУТМ(Реквизиты, ПараметрыВыполненияЗапросов.ПараметрыЗапроса.Ссылка);
	КонецЕсли;

	ДанныеВыгружаемогоОбъекта = Новый Структура;
	ДанныеВыгружаемогоОбъекта.Вставить("ПолноеИмя", ПараметрыВыполненияЗапросов.ПолноеИмя);
	ДанныеВыгружаемогоОбъекта.Вставить("Реквизиты", Реквизиты);
	
	Возврат ДанныеВыгружаемогоОбъекта;
	
КонецФункции

#КонецОбласти // Конец Переопределяемые

#КонецОбласти // Конец ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ИменаВыгружаемыхРеквизитов()

	ИменаВыгружаемыхРеквизитов = ВыгружаемыеРеквизитыШапки() + ", " + ВыгружаемыеРеквизитыТовары();
	ИменаВыгружаемыхРеквизитов = СтрЗаменить(ИменаВыгружаемыхРеквизитов, Символы.ПС, "");
	ИменаВыгружаемыхРеквизитов = СтрЗаменить(ИменаВыгружаемыхРеквизитов, " ", "");
	
	Возврат ИменаВыгружаемыхРеквизитов;

КонецФункции

Функция ВыгружаемыеРеквизитыШапки()

	Возврат
	"Дата,
	| Номер,
	| Проведен,
	| ПометкаУдаления,
	| Организация,
	| ОрганизацияЕГАИС,
	| Поставщик,
	| ИдентификаторЕГАИС,
	| ДатаИмпорта,
	| НомерКонтракта,
	| ДатаКонтракта,
	| НомерГТД,
	| ДатаГТД,
	| КодСтраны,
	| Комментарий";

КонецФункции

Функция ВыгружаемыеРеквизитыТовары()

	Возврат
	"Товары.Серия,
	| Товары.Количество,
	| Товары.НомерПартии,
	| Товары.Крепость,
	| Товары.КрепостьМин,
	| Товары.КрепостьМакс";

КонецФункции

Функция ТекстЗапросаВыгружаемыхДанных()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	битОтчетОбИмпортеПродукцииЕГАИС.Ссылка КАК Идентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Ссылка КАК ТаблицаКлючей,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ПометкаУдаления КАК ПометкаУдаления,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Проведен КАК Проведен,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Дата КАК Дата,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Номер КАК Номер,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Комментарий КАК Комментарий,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Организация КАК Организация_ЗначениеРеквизитаИдентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Организация КАК Организация_ЗначениеРеквизитаТаблицаКлючей,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС_ЗначениеРеквизитаИдентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС_ЗначениеРеквизитаТаблицаКлючей,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ОрганизацияЕГАИС.Код КАК ОрганизацияЕГАИС_ЗначениеРеквизитаКод,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Склад КАК ПунктРазгрузкиИдентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Поставщик КАК Поставщик_ЗначениеРеквизитаИдентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Поставщик КАК Поставщик_ЗначениеРеквизитаТаблицаКлючей,
	|	битОтчетОбИмпортеПродукцииЕГАИС.Поставщик.Код КАК Поставщик_ЗначениеРеквизитаКод,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ДатаИмпорта КАК ДатаИмпорта,
	|	битОтчетОбИмпортеПродукцииЕГАИС.НомерКонтракта КАК НомерКонтракта,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ДатаКонтракта КАК ДатаКонтракта,
	|	битОтчетОбИмпортеПродукцииЕГАИС.НомерГТД КАК НомерГТД,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ДатаГТД КАК ДатаГТД,
	|	битОтчетОбИмпортеПродукцииЕГАИС.КодСтраны КАК КодСтраны,
	|	ПРЕДСТАВЛЕНИЕ(СтатусыДокументовЕГАИС.Статус) КАК СтатусДокумента,
	|	битОтчетОбИмпортеПродукцииЕГАИС.ДокументОснование КАК ДокументОснованиеИдентификатор
	|ИЗ
	|	Документ.битОтчетОбИмпортеПродукцииЕГАИС КАК битОтчетОбИмпортеПродукцииЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО битОтчетОбИмпортеПродукцииЕГАИС.Ссылка = СтатусыДокументовЕГАИС.Документ
	|ГДЕ
	|	битОтчетОбИмпортеПродукцииЕГАИС.Ссылка = &Ссылка
	|	И (СтатусыДокументовЕГАИС.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.бг_Подтвержден)
	|			ИЛИ СтатусыДокументовЕГАИС.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Отменен))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.АлкогольнаяПродукция.Код КАК АлкогольнаяПродукцияКод,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.Серия КАК Серия_ЗначениеРеквизитаИдентификатор,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.Серия КАК Серия_ЗначениеРеквизитаТаблицаКлючей,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.НомерПартии КАК НомерПартии,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.Количество КАК Количество,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.Крепость КАК Крепость,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.КрепостьМин КАК КрепостьМин,
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.КрепостьМакс КАК КрепостьМакс,
	|	ЕСТЬNULL(битОтчетОбИмпортеПродукцииЕГАИСТовары.Справка1.РегистрационныйНомер, """") КАК Справка1РегистрационныйНомер,
	|	ЕСТЬNULL(битОтчетОбИмпортеПродукцииЕГАИСТовары.Справка2.РегистрационныйНомер, """") КАК Справка2РегистрационныйНомер
	|ИЗ
	|	Документ.битОтчетОбИмпортеПродукцииЕГАИС.Товары КАК битОтчетОбИмпортеПродукцииЕГАИСТовары
	|ГДЕ
	|	битОтчетОбИмпортеПродукцииЕГАИСТовары.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ЗаполнитьСтроковыйИдентификаторСвойства(Реквизиты, ИмяСвойства)

	// Сопоставляем ПунктРазгрузки только по ГУИДу. Передаем идентификатор в строковом виде без учета
	// типов данных источника для упрощения, объектов для сопоставления очень мало.
	
	Если Реквизиты.Количество() > 0 Тогда
		
		Если Реквизиты[0].Свойство(ИмяСвойства) Тогда
			Реквизиты[0][ИмяСвойства] = Строка(Реквизиты[0][ИмяСвойства].УникальныйИдентификатор());
		Иначе
			Реквизиты[0].Вставить(ИмяСвойства, "");
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьИдентификаторЗапросаУТМ(Реквизиты, СсылкаНаДокумент)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕГАИСПрисоединенныеФайлы.ИдентификаторЗапроса КАК ИдентификаторЗапроса
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.Документ = &Документ
	|	И ЕГАИСПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.бг_УведомлениеОРегистрацииДвиженияОтчетаОбИмпортеПроизводстве)";
	Запрос.УстановитьПараметр("Документ", СсылкаНаДокумент);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Реквизиты[0].Вставить("ИдентификаторЗапросаУТМ", Выборка.ИдентификаторЗапроса);
	Иначе 
		Реквизиты[0].Вставить("ИдентификаторЗапросаУТМ", "");
	КонецЕсли;
	 
КонецПроцедуры

#КонецОбласти // Конец СлужебныеПроцедурыИФункции
