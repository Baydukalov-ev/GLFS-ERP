#Область ПрограммныйИнтерфейс

#Область Проведение

&После("ЗарегистрироватьУчетныеМеханизмы")
Процедура бг_ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента)
	
	МеханизмыДокумента.Добавить("бг_УчетБанковскихГарантий");
	
КонецПроцедуры

#КонецОбласти

#Область АкцизыПоПриобретеннымЦенностям

Функция бг_ТребуетсяЗаполнениеАкцизовПоПриобретеннымЦенностям(ДокументОбъект) Экспорт
	Если Не бг_УчетБанковскихГарантий.ВестиУчетАкцизовПоПриобретеннымЦенностям(ДокументОбъект) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если бг_УчетБанковскихГарантий.ТребуетсяЗаполнениеАкцизовПоПриобретеннымЦенностям(ДокументОбъект) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ВыходныеИзделия.Серия КАК Серия,
	|	ВыходныеИзделия.Количество КАК Количество
	|ПОМЕСТИТЬ ВыходныеИзделия
	|ИЗ
	|	&ВыходныеИзделия КАК ВыходныеИзделия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходМатериаловИРабот.Номенклатура КАК Номенклатура,
	|	РасходМатериаловИРабот.Серия КАК Серия,
	|	РасходМатериаловИРабот.Количество КАК Количество
	|ПОМЕСТИТЬ РасходМатериаловИРабот
	|ИЗ
	|	&РасходМатериаловИРабот КАК РасходМатериаловИРабот
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходМатериаловИРабот.Номенклатура КАК Номенклатура,
	|	РасходМатериаловИРабот.Серия КАК Серия,
	|	- РасходМатериаловИРабот.Количество КАК Количество
	|ПОМЕСТИТЬ Данные
	|ИЗ
	|	РасходМатериаловИРабот КАК РасходМатериаловИРабот
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВыходныеИзделия.Номенклатура,
	|	ВыходныеИзделия.Серия,
	|	ВыходныеИзделия.Количество
	|ИЗ
	|	ВыходныеИзделия КАК ВыходныеИзделия
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АкцизВыпускПродукции.Номенклатура,
	|	АкцизВыпускПродукции.СерияНоменклатуры,
	|	ВЫБОР
	|		КОГДА АкцизВыпускПродукции.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА -АкцизВыпускПродукции.Количество
	|		ИНАЧЕ АкцизВыпускПродукции.Количество
	|	КОНЕЦ
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностямВыпускПродукции КАК АкцизВыпускПродукции
	|ГДЕ
	|	АкцизВыпускПродукции.Регистратор = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Данные.Номенклатура КАК Номенклатура,
	|	Данные.Серия КАК Серия,
	|	СУММА(Данные.Количество) КАК Количество
	|ИЗ
	|	Данные КАК Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	Данные.Номенклатура,
	|	Данные.Серия
	|
	|ИМЕЮЩИЕ
	|	СУММА(Данные.Количество) <> 0";
	Запрос.УстановитьПараметр("ВыходныеИзделия", ДокументОбъект.ВыходныеИзделия.Выгрузить(, "Номенклатура, Серия, Количество"));
	Запрос.УстановитьПараметр("РасходМатериаловИРабот", ДокументОбъект.МатериалыИРаботы.Выгрузить(, "Номенклатура, Серия, Количество"));
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
КонецФункции

Функция бг_СтатусыСостоянияСписываемогоСырья() Экспорт
	СтатусыСостояния = бг_УчетБанковскихГарантий.СтатусыСостоянияСписываемогоСырья();
	
	СтатусыСостояния.СтатусыАкциза.Добавить(Перечисления.бг_СостоянияОплатыВходящегоАкциза.АвансовыйАкцизВСырье);
	СтатусыСостояния.СтатусыАкциза.Добавить(Перечисления.бг_СостоянияОплатыВходящегоАкциза.АкцизПоОплаченнымМЦ);
	СтатусыСостояния.СтатусыАкциза.Добавить(Перечисления.бг_СостоянияОплатыВходящегоАкциза.АкцизПоНеОплаченнымМЦ);
	СтатусыСостояния.СтатусыАкциза.Добавить(Перечисления.бг_СостоянияОплатыВходящегоАкциза.АкцизПоВозвращеннойПродукции);
	
	СтатусыСостояния.СостоянияСырья.Добавить(Перечисления.бг_СостоянияПодакцизногоСырья.ВПроизводстве);
	
	Возврат СтатусыСостояния;
КонецФункции

Функция бг_ТекстЗапросаДвиженияАкцизыПоПриобретеннымЦенностям() Экспорт
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Документ.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	Документ.Организация КАК Организация,
	|	АкцизПоПриобретеннымЦенностям.Номенклатура КАК Номенклатура,
	|	АкцизПоПриобретеннымЦенностям.СерияНоменклатуры КАК СерияНоменклатуры,
	|	АкцизПоПриобретеннымЦенностям.Сделка КАК Сделка,
	|	АкцизПоПриобретеннымЦенностям.СостояниеСырья КАК СостояниеСырья,
	|	АкцизПоПриобретеннымЦенностям.СтатусАкциза КАК СтатусАкциза,
	|	АкцизПоПриобретеннымЦенностям.СостояниеОплатыАванса КАК СостояниеОплатыАванса,
	|	АкцизПоПриобретеннымЦенностям.Количество КАК Количество,
	|	АкцизПоПриобретеннымЦенностям.Продукция КАК Продукция,
	|	АкцизПоПриобретеннымЦенностям.СерияПродукции КАК СерияПродукции
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводствоБезЗаказа.бг_АкцизПоПриобретеннымЦенностямМатериалы КАК АкцизПоПриобретеннымЦенностям
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = АкцизПоПриобретеннымЦенностям.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Документ.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	Документ.Организация,
	|	АкцизПоПриобретеннымЦенностям.Номенклатура,
	|	АкцизПоПриобретеннымЦенностям.СерияНоменклатуры,
	|	АкцизПоПриобретеннымЦенностям.Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.бг_СостоянияПодакцизногоСырья.ВСпиртосодержащейСмеси),
	|	АкцизПоПриобретеннымЦенностям.СтатусАкциза,
	|	АкцизПоПриобретеннымЦенностям.СостояниеОплатыАванса,
	|	АкцизПоПриобретеннымЦенностям.Количество,
	|	АкцизПоПриобретеннымЦенностям.Продукция,
	|	АкцизПоПриобретеннымЦенностям.СерияПродукции
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводствоБезЗаказа.бг_АкцизПоПриобретеннымЦенностямПродукция КАК АкцизПоПриобретеннымЦенностям
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = АкцизПоПриобретеннымЦенностям.Ссылка";
	
	Возврат ТекстЗапроса;
КонецФункции

Функция бг_ТекстЗапросаДвиженияАкцизыПоПриобретеннымЦенностямПродукция() Экспорт
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизМатериалы.Продукция КАК Номенклатура,
	|	АкцизМатериалы.СерияПродукции КАК СерияНоменклатуры
	|ПОМЕСТИТЬ Продукция
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа.бг_АкцизПоПриобретеннымЦенностямМатериалы КАК АкцизМатериалы
	|ГДЕ
	|	АкцизМатериалы.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизПродукция.Продукция,
	|	АкцизПродукция.СерияПродукции
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа.бг_АкцизПоПриобретеннымЦенностямПродукция КАК АкцизПродукция
	|ГДЕ
	|	АкцизПродукция.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документ.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Документ.Организация КАК Организация,
	|	ДокументВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ДокументВыходныеИзделия.Серия КАК СерияНоменклатуры,
	|	ЗНАЧЕНИЕ(Перечисление.бг_ТипыМестХраненияПодакцизнойПродукции.Склад) КАК ТипМестаХранения,
	|	ДокументВыходныеИзделия.Количество КАК Количество
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводствоБезЗаказа.ВыходныеИзделия КАК ДокументВыходныеИзделия
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = ДокументВыходныеИзделия.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Продукция КАК Продукция
	|		ПО (ДокументВыходныеИзделия.Номенклатура = Продукция.Номенклатура)
	|			И (ДокументВыходныеИзделия.Серия = Продукция.СерияНоменклатуры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Документ.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	Документ.Организация,
	|	ДокументМатериалыИРаботы.Номенклатура,
	|	ДокументМатериалыИРаботы.Серия,
	|	ЗНАЧЕНИЕ(Перечисление.бг_ТипыМестХраненияПодакцизнойПродукции.Подразделение),
	|	ДокументМатериалыИРаботы.Количество
	|ИЗ
	|	Документ.ПроизводствоБезЗаказа КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроизводствоБезЗаказа.МатериалыИРаботы КАК ДокументМатериалыИРаботы
	|		ПО (Документ.Ссылка = &Ссылка)
	|			И Документ.Ссылка = ДокументМатериалыИРаботы.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Продукция КАК Продукция
	|		ПО (ДокументМатериалыИРаботы.Номенклатура = Продукция.Номенклатура)
	|			И (ДокументМатериалыИРаботы.Серия = Продукция.СерияНоменклатуры)";
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

&После("ДополнитьТекстыЗапросовПроведения")
Процедура бг_ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры)
	
	бг_ДополнитьТекстыЗапросовПроведенияАкцизыПоПриобретеннымЦенностям(Запрос, ТекстыЗапроса, Регистры);
	бг_ДополнитьТекстыЗапросовПроведенияАкцизыПоПриобретеннымЦенностямПродукция(Запрос, ТекстыЗапроса, Регистры);
	
КонецПроцедуры

Процедура бг_ДополнитьТекстыЗапросовПроведенияАкцизыПоПриобретеннымЦенностям(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "бг_АкцизПоПриобретеннымЦенностям";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(бг_ТекстЗапросаДвиженияАкцизыПоПриобретеннымЦенностям(), ИмяРегистра);
	
КонецПроцедуры

Процедура бг_ДополнитьТекстыЗапросовПроведенияАкцизыПоПриобретеннымЦенностямПродукция(Запрос, ТекстыЗапроса, Регистры)
	ИмяРегистра = "бг_АкцизПоПриобретеннымЦенностямВыпускПродукции";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(бг_ТекстЗапросаДвиженияАкцизыПоПриобретеннымЦенностямПродукция(), ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
