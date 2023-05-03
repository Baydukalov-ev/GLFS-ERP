#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

&После("ЗарегистрироватьУчетныеМеханизмы")
Процедура бг_ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента)
	
	МеханизмыДокумента.Добавить("бг_УчетБанковскихГарантий");
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	
КонецПроцедуры

Процедура бг_СформироватьДвиженияПодтверждениеОплаты(ЗаявлениеОВвозеТоваров) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодтверждениеОплатыНДСВБюджет.СчетФактура КАК СчетФактура,
	|	МАКСИМУМ(ПодтверждениеОплатыНДСВБюджет.ДатаПодтвержденияОплаты) КАК ДатаПодтвержденияОплаты
	|ПОМЕСТИТЬ ПодтверждениеОплаты
	|ИЗ
	|	РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК ПодтверждениеОплатыНДСВБюджет
	|ГДЕ
	|	ПодтверждениеОплатыНДСВБюджет.СчетФактура = &Ссылка
	|	И ПодтверждениеОплатыНДСВБюджет.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.ПолученоПодтверждение)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодтверждениеОплатыНДСВБюджет.СчетФактура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АкцизОстатки.Организация КАК Организация,
	|	АкцизОстатки.Номенклатура КАК Номенклатура,
	|	АкцизОстатки.СерияНоменклатуры КАК СерияНоменклатуры,
	|	АкцизОстатки.Сделка КАК Сделка,
	|	АкцизОстатки.СостояниеСырья КАК СостояниеСырья,
	|	АкцизОстатки.СтатусАкциза КАК СтатусАкциза,
	|	АкцизОстатки.Продукция КАК Продукция,
	|	АкцизОстатки.СерияПродукции КАК СерияПродукции,
	|	АкцизОстатки.КоличествоОстаток КАК Количество
	|ПОМЕСТИТЬ ОстаткиАкциза
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностям.Остатки(
	|			,
	|			Сделка В
	|					(ВЫБРАТЬ
	|						ЗаявлениеОВвозеТоваровТовары.ДокументПоступления КАК ДокументПоступления
	|					ИЗ
	|						Документ.ЗаявлениеОВвозеТоваров.Товары КАК ЗаявлениеОВвозеТоваровТовары
	|					ГДЕ
	|						ЗаявлениеОВвозеТоваровТовары.Ссылка = &Ссылка
	|						И ЗаявлениеОВвозеТоваровТовары.ДокументПоступления.бг_ДиапазонБанковскихГарантий = ЗНАЧЕНИЕ(Справочник.бг_БанковскиеГарантии.ПустаяСсылка))
	|				И СтатусАкциза = ЗНАЧЕНИЕ(Перечисление.бг_СостоянияОплатыВходящегоАкциза.АкцизПоНеОплаченнымМЦ)) КАК АкцизОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Акциз.Организация,
	|	Акциз.Номенклатура,
	|	Акциз.СерияНоменклатуры,
	|	Акциз.Сделка,
	|	Акциз.СостояниеСырья,
	|	Акциз.СтатусАкциза,
	|	Акциз.Продукция,
	|	Акциз.СерияПродукции,
	|	Акциз.Количество
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностям КАК Акциз
	|ГДЕ
	|	Акциз.Регистратор = &Ссылка
	|	И Акциз.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодтверждениеОплаты.ДатаПодтвержденияОплаты КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ОстаткиАкциза.Организация КАК Организация,
	|	ОстаткиАкциза.Номенклатура КАК Номенклатура,
	|	ОстаткиАкциза.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ОстаткиАкциза.Сделка КАК Сделка,
	|	ОстаткиАкциза.СостояниеСырья КАК СостояниеСырья,
	|	ОстаткиАкциза.СтатусАкциза КАК СтатусАкциза,
	|	ОстаткиАкциза.Продукция КАК Продукция,
	|	ОстаткиАкциза.СерияПродукции КАК СерияПродукции,
	|	СУММА(ОстаткиАкциза.Количество) КАК Количество
	|ИЗ
	|	Документ.ЗаявлениеОВвозеТоваров КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОстаткиАкциза КАК ОстаткиАкциза
	|		ПО (Документ.Ссылка = &Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПодтверждениеОплаты КАК ПодтверждениеОплаты
	|		ПО Документ.Ссылка = ПодтверждениеОплаты.СчетФактура
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодтверждениеОплаты.ДатаПодтвержденияОплаты,
	|	ОстаткиАкциза.СерияПродукции,
	|	ОстаткиАкциза.Сделка,
	|	ОстаткиАкциза.Организация,
	|	ОстаткиАкциза.СерияНоменклатуры,
	|	ОстаткиАкциза.Продукция,
	|	ОстаткиАкциза.СостояниеСырья,
	|	ОстаткиАкциза.СтатусАкциза,
	|	ОстаткиАкциза.Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПодтверждениеОплаты.ДатаПодтвержденияОплаты,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ОстаткиАкциза.Организация,
	|	ОстаткиАкциза.Номенклатура,
	|	ОстаткиАкциза.СерияНоменклатуры,
	|	ОстаткиАкциза.Сделка,
	|	ОстаткиАкциза.СостояниеСырья,
	|	ЗНАЧЕНИЕ(Перечисление.бг_СостоянияОплатыВходящегоАкциза.АкцизПоОплаченнымМЦ),
	|	ОстаткиАкциза.Продукция,
	|	ОстаткиАкциза.СерияПродукции,
	|	СУММА(ОстаткиАкциза.Количество)
	|ИЗ
	|	Документ.ЗаявлениеОВвозеТоваров КАК Документ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОстаткиАкциза КАК ОстаткиАкциза
	|		ПО (Документ.Ссылка = &Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПодтверждениеОплаты КАК ПодтверждениеОплаты
	|		ПО Документ.Ссылка = ПодтверждениеОплаты.СчетФактура
	|
	|СГРУППИРОВАТЬ ПО
	|	ПодтверждениеОплаты.ДатаПодтвержденияОплаты,
	|	ОстаткиАкциза.СерияПродукции,
	|	ОстаткиАкциза.Сделка,
	|	ОстаткиАкциза.Организация,
	|	ОстаткиАкциза.СерияНоменклатуры,
	|	ОстаткиАкциза.Продукция,
	|	ОстаткиАкциза.СостояниеСырья,
	|	ОстаткиАкциза.СтатусАкциза,
	|	ОстаткиАкциза.Номенклатура";
	Запрос.УстановитьПараметр("Ссылка", ЗаявлениеОВвозеТоваров);
	Результат = Запрос.Выполнить();
	
	НаборЗаписей = РегистрыНакопления.бг_АкцизПоПриобретеннымЦенностям.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ЗаявлениеОВвозеТоваров);
	НаборЗаписей.Загрузить(Результат.Выгрузить());
	НаборЗаписей.Записать();
КонецПроцедуры

#КонецОбласти

#Область ПроводкиРеглУчета

&Вместо("ТекстОтраженияВРеглУчете")
Функция бг_ТекстОтраженияВРеглУчете()
	ТекстЗапроса = ПродолжитьВызов();
	ТекстЗапроса = ТекстЗапроса + ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении() + 
	ТекстОтраженияНачисленияАкциза();
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область СлужебныеПроцедурыИФункции

Функция ТекстОтраженияНачисленияАкциза()

	ТекстЗапроса = 
	// Заявление возмещение акциза <Дт 19.06 :: Кт 68.03>
	"ВЫБРАТЬ
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	СУММА(Строки.СуммаАкциза) КАК Сумма,
	|	СУММА(Строки.СуммаАкциза) КАК СуммаУУ,
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.АкцизыПоОплаченнымМатериальнымЦенностям) КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Акцизы) КАК СчетКт,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.Налог) КАК СубконтоКт1,
	|	Операция.Организация.РегистрацияВНалоговомОргане КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Начисление акциза"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеОВвозеТоваров КАК Операция
	|		ПО ДокументыКОтражению.Ссылка = Операция.Ссылка
	|			И Операция.Дата >= Операция.Организация.бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеОВвозеТоваров.Товары КАК Строки
	|		ПО (Строки.Ссылка = Операция.Ссылка) И Строки.СуммаАкциза <> 0 
	|
	|СГРУППИРОВАТЬ ПО
	|	Операция.Ссылка,
	|	Операция.Дата,
	|	Операция.Организация,
	|	Операция.Подразделение,
	|	Строки.Номенклатура.ГруппаФинансовогоУчета";
	
	Возврат ТекстЗапроса;

КонецФункции 

#КонецОбласти
