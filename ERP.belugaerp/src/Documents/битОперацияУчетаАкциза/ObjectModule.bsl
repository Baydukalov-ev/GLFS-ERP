#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаполнитьАкцизыПоПриобретеннымЦенностям(Отказ);
	КонецЕсли;
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.бг_АкцизПоПриобретеннымЦенностям.Записывать = Истина;
	Движения.бг_АкцизПоПриобретеннымЦенностямВыпускПродукции.Записывать = Истина;
	
	Если ВидОперации = Перечисления.бг_ВидыОперацийУчетаАкцизов.ПодтверждениеЭкспорта Тогда
		СформироватьДвиженияПодтверждениеЭкспортаАкцизПоПриобретеннымЦенностям(Отказ);
		СформироватьДвиженияПодтверждениеЭкспортаАкцизПоПриобретеннымЦенностямПродукция(Отказ);
	КонецЕсли;
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ИнициализироватьДокумент(ДанныеЗаполнения);
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	ИнициализироватьДокумент();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	Автор = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ЗаполнитьАкцизыПоПриобретеннымЦенностям(Отказ)
	Если ВидОперации = Перечисления.бг_ВидыОперацийУчетаАкцизов.ПодтверждениеЭкспорта Тогда
		ЗаполнитьАкцизыПоПриобретеннымЦенностямПодтверждениеЭкспорта(Отказ);
	КонецЕсли;
КонецПроцедуры

#Область ПодтверждениеЭкспорта

Процедура ЗаполнитьАкцизыПоПриобретеннымЦенностямПодтверждениеЭкспорта(Отказ)
	УстановитьПривилегированныйРежим(Истина);
	
	СтатусыСостоянияСписываемогоСырья = Документы.битОперацияУчетаАкциза.СтатусыСостоянияСписываемогоСырья();
	
	МассивТекстов = Новый Массив;
	
	ТестЗапроса = бг_УчетБанковскихГарантий.ТекстЗапросаТаблицаМатериалы();
	ТестЗапроса = СтрЗаменить(ТестЗапроса, "ДатаВремя(01,01,01) КАК ДатаРеализации", "ДатаРеализации КАК ДатаРеализации");
	МассивТекстов.Добавить(ТестЗапроса);

	ТестЗапроса = бг_УчетБанковскихГарантий.ТекстЗапросаОстаткиАкцизовПоПродукции();
	ТестЗапроса = СтрЗаменить(ТестЗапроса, 
	"(Продукция, СерияПродукции) В
	|					(ВЫБРАТЬ
	|						Товары.Номенклатура КАК Номенклатура,
	|						Товары.Серия КАК Серия
	|					ИЗ
	|						Товары КАК Товары)",
	"(ДатаРеализации, Продукция, СерияПродукции) В
	|					(ВЫБРАТЬ
	|						Товары.ДатаРеализации,
	|						Товары.Номенклатура КАК Номенклатура,
	|						Товары.Серия КАК Серия
	|					ИЗ
	|						Товары КАК Товары)");
	МассивТекстов.Добавить(ТестЗапроса);
	
	ТестЗапроса = бг_УчетБанковскихГарантий.ТекстЗапросаОстаткиВыпущеннойПродукции();
	ТестЗапроса = СтрЗаменить(ТестЗапроса, 
	"(Номенклатура, СерияНоменклатуры) В
	|					(ВЫБРАТЬ
	|						Товары.Номенклатура КАК Номенклатура,
	|						Товары.Серия КАК Серия
	|					ИЗ
	|						Товары КАК Товары)",
	"(ДатаРеализации, Номенклатура, СерияНоменклатуры) В
	|					(ВЫБРАТЬ
	|						Товары.ДатаРеализации,
	|						Товары.Номенклатура КАК Номенклатура,
	|						Товары.Серия КАК Серия
	|					ИЗ
	|						Товары КАК Товары)");
	МассивТекстов.Добавить(ТестЗапроса);

	МассивТекстов.Добавить(бг_УчетБанковскихГарантий.ТекстЗапросаРасчетСписанияАкцизовПоПродукции());
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(МассивТекстов, ОбщегоНазначенияУТ.РазделительЗапросовВПакете());
	
	Запрос.УстановитьПараметр("Ссылка",           Ссылка);
	Если ДополнительныеСвойства.Свойство("бг_ЗаполнитьАкцизыПоПриобретеннымЦенностям")
		И ДополнительныеСвойства.бг_ЗаполнитьАкцизыПоПриобретеннымЦенностям = Истина Тогда
		ДатаОстатков = Новый Граница(КонецДня(Дата), ВидГраницы.Включая);
	Иначе
		ДатаОстатков = '00010101';
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаОстатков",         ДатаОстатков);
	Запрос.УстановитьПараметр("Товары",           ПодтверждаемаяПродукция());
	Запрос.УстановитьПараметр("Организация",      Организация);
	Запрос.УстановитьПараметр("СтатусыАкциза",    СтатусыСостоянияСписываемогоСырья.СтатусыАкциза);
	Запрос.УстановитьПараметр("СостоянияСырья",   СтатусыСостоянияСписываемогоСырья.СостоянияСырья);
	Запрос.УстановитьПараметр("ТипМестаХранения", Перечисления.бг_ТипыМестХраненияПодакцизнойПродукции.ВОжиданииПодтвержденияЭкспорта);
	
	ТочностьУчетаМатериалов = РегистрыНакопления.бг_АкцизПоПриобретеннымЦенностям.ТочностьУчетаПодакцизныхМатериалов();
	Запрос.УстановитьПараметр("ТочностьУчета", ТочностьУчетаМатериалов);
	
	Результат = Запрос.Выполнить();
	АкцизПоПриобретеннымЦенностям.Загрузить(Результат.Выгрузить());
КонецПроцедуры

Функция ПодтверждаемаяПродукция()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АВТОНОМЕРЗАПИСИ() КАК НомерСтроки,
	|	НАЧАЛОПЕРИОДА(РеализацияТоваровУслугТовары.Ссылка.Дата, ДЕНЬ) КАК ДатаРеализации,
	|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	РеализацияТоваровУслугТовары.Серия КАК Серия,
	|	СУММА(РеализацияТоваровУслугТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка В(&Ссылка)
	|	И РеализацияТоваровУслугТовары.Ссылка.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(РеализацияТоваровУслугТовары.Ссылка.Дата, ДЕНЬ),
	|	РеализацияТоваровУслугТовары.Номенклатура,
	|	РеализацияТоваровУслугТовары.Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.ДатаРеализации,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество
	|ИЗ
	|	Товары КАК Товары";
	Запрос.УстановитьПараметр("Ссылка", ДокументыПодтверждениеЭкспорта.ВыгрузитьКолонку("Документ"));
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
КонецФункции

Процедура СформироватьДвиженияПодтверждениеЭкспортаАкцизПоПриобретеннымЦенностям(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Документ.Организация КАК Организация,
	|	Акцизы.Номенклатура КАК Номенклатура,
	|	Акцизы.СерияНоменклатуры КАК СерияНоменклатуры,
	|	Акцизы.Сделка КАК Сделка,
	|	Акцизы.СостояниеСырья КАК СостояниеСырья,
	|	Акцизы.СтатусАкциза КАК СтатусАкциза,
	|	Акцизы.СостояниеОплатыАванса КАК СостояниеОплатыАванса,
	|	Акцизы.Продукция КАК Продукция,
	|	Акцизы.СерияПродукции КАК СерияПродукции,
	|	Акцизы.ДатаРеализации КАК ДатаРеализации,
	|	Акцизы.Количество КАК Количество
	|ИЗ
	|	Документ.битОперацияУчетаАкциза КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.битОперацияУчетаАкциза.АкцизПоПриобретеннымЦенностям КАК Акцизы
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = Акцизы.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Документ.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	Документ.Организация,
	|	Акцизы.Номенклатура,
	|	Акцизы.СерияНоменклатуры,
	|	Акцизы.Сделка,
	|	ВЫБОР
	|		КОГДА Акцизы.СостояниеСырья = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ВОжиданииПодтвержденияЭкспорта)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ПодтвержденЭкспорт)
	|		КОГДА Акцизы.СостояниеСырья = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ВОжиданииПодтвержденияЭкспортаЕАЭС)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ПодтвержденЭкспортЕАЭС)
	|		КОГДА Акцизы.СостояниеСырья = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ВОжиданииПодтвержденияЭкспортаГарантии)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ПодтвержденЭкспортГарантии)
	|		КОГДА Акцизы.СостояниеСырья = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ВОжиданииПодтвержденияЭкспортаГарантииЕАЭС)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ПодтвержденЭкспортЕАЭСГарантии)
	|	КОНЕЦ,
	|	Акцизы.СтатусАкциза,
	|	Акцизы.СостояниеОплатыАванса,
	|	Акцизы.Продукция,
	|	Акцизы.СерияПродукции,
	|	Акцизы.ДатаРеализации,
	|	Акцизы.Количество
	|ИЗ
	|	Документ.битОперацияУчетаАкциза КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.битОперацияУчетаАкциза.АкцизПоПриобретеннымЦенностям КАК Акцизы
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = Акцизы.Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Движения.бг_АкцизПоПриобретеннымЦенностям.Загрузить(Результат.Выгрузить());
КонецПроцедуры

Процедура СформироватьДвиженияПодтверждениеЭкспортаАкцизПоПриобретеннымЦенностямПродукция(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Акцизы.Продукция КАК Продукция,
	|	Акцизы.СерияПродукции КАК СерияПродукции
	|ПОМЕСТИТЬ ПодтвержденнаяПродукция
	|ИЗ
	|	Документ.битОперацияУчетаАкциза.АкцизПоПриобретеннымЦенностям КАК Акцизы
	|ГДЕ
	|	Акцизы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыПодтверждение.Документ КАК Документ
	|ПОМЕСТИТЬ ДокументыПодтверждение
	|ИЗ
	|	Документ.битОперацияУчетаАкциза.ДокументыПодтверждениеЭкспорта КАК ДокументыПодтверждение
	|ГДЕ
	|	ДокументыПодтверждение.Ссылка = &Ссылка
	|	И ДокументыПодтверждение.Документ.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	РеализацияТоваровУслугТовары.Серия КАК СерияНоменклатуры,
	|	ЗНАЧЕНИЕ(Перечисление.бг_ТипыМестХраненияПодакцизнойПродукции.ВОжиданииПодтвержденияЭкспорта) КАК ТипМестаХранения,
	|	НачалоПериода(ДокументыПодтверждение.Документ.Дата, День) КАК ДатаРеализации,
	|	СУММА(РеализацияТоваровУслугТовары.Количество) КАК Количество
	|ИЗ
	|	ДокументыПодтверждение КАК ДокументыПодтверждение
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|		ПО ДокументыПодтверждение.Документ = РеализацияТоваровУслугТовары.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровУслугТовары.Номенклатура,
	|	РеализацияТоваровУслугТовары.Серия,
	|	НачалоПериода(ДокументыПодтверждение.Документ.Дата, День)";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	Движения.бг_АкцизПоПриобретеннымЦенностямВыпускПродукции.Загрузить(Результат.Выгрузить());
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
