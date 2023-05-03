#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьДублированиеОтчетаОПроизводстве(Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

&После("ПриЗаписи")
Процедура бг_ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);

КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	ИдентификаторЕГАИС      = "";
	Товары.Очистить();
	
КонецПроцедуры

&После("ОбработкаПроведения")
Процедура бг_ОбработкаПроведения(Отказ, РежимПроведения)
	Если ЕстьОшибкиЗаполненияСырья(Отказ) Тогда
		Возврат;
	КонецЕсли;
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.битОтчетОПроизводствеЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ОтразитьДвиженияМарок(ДополнительныеСвойства, Движения);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);

	ЗарегистрироватьСоответствиеНоменклатурыЕГАИС(Отказ);
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭтапПроизводства2_2") Тогда
		ЗаполнитьНаОснованииЭтапаПроизводства(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

&После("ОбработкаПроверкиЗаполнения")
Процедура бг_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	бг_ИнтеграцияЕГАИС.ПроверитьЗаполнениеАлкогольнойПродукции(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&После("ОбработкаУдаленияПроведения")
Процедура бг_ОбработкаУдаленияПроведения(Отказ)
	РегистрыСведений.СоответствиеНоменклатурыЕГАИС.бг_ОчиститьСоответствиеНоменклатурыЕГАИС(Товары);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЕстьОшибкиЗаполненияСырья(Отказ) 
	Результат = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	битОтчетОПроизводствеЕГАИССырьё.НомерСтроки КАК НомерСтроки,
	|	битОтчетОПроизводствеЕГАИССырьё.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	битОтчетОПроизводствеЕГАИССырьё.Серия КАК Серия,
	|	битОтчетОПроизводствеЕГАИССырьё.Справка2 КАК Справка2,
	|	СерииНоменклатуры.Справка2ЕГАИС КАК Справка2Серия,
	|	ЕСТЬNULL(СерииНоменклатуры.Справка2ЕГАИС.АлкогольнаяПродукция, НЕОПРЕДЕЛЕНО) КАК АлкогольнаяПродукцияСерия
	|ИЗ
	|	Документ.битОтчетОПроизводствеЕГАИС.Сырьё КАК битОтчетОПроизводствеЕГАИССырьё
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|		ПО битОтчетОПроизводствеЕГАИССырьё.Серия = СерииНоменклатуры.Ссылка
	|			И (битОтчетОПроизводствеЕГАИССырьё.Ссылка = &Ссылка)
	|			И НЕ(битОтчетОПроизводствеЕГАИССырьё.Справка2 = СерииНоменклатуры.Справка2ЕГАИС
	|				И битОтчетОПроизводствеЕГАИССырьё.АлкогольнаяПродукция = ЕСТЬNULL(СерииНоменклатуры.Справка2ЕГАИС.АлкогольнаяПродукция, НЕОПРЕДЕЛЕНО))";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	ТекстОшибкиСправка2 = НСтр("ru='В строке %1 справка 2 в серии сырья %2 не соответствует справке 2 в строке %3'");
	ТекстОшибкиАлкогольнаяПродукция = 
		НСтр("ru='В строке %1 алкогольная продукция в серии сырья %2 не соответствует алкогольной продукции в строке %3'");
	Пока Выборка.Следующий() Цикл
		Результат = Истина;
		Если Не Выборка.Справка2 = Выборка.Справка2Серия Тогда
			ТекстОшибки = СтрШаблон(ТекстОшибкиСправка2, 
				Выборка.НомерСтроки,
				Выборка.Справка2Серия,
				Выборка.Справка2);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки, 
				ЭтотОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сырьё", Выборка.НомерСтроки, "Справка2")
				, 
				, 
				Отказ);	
		КонецЕсли;
		Если Не Выборка.АлкогольнаяПродукция = Выборка.АлкогольнаяПродукцияСерия Тогда
			ТекстОшибки = СтрШаблон(ТекстОшибкиАлкогольнаяПродукция, 
				Выборка.НомерСтроки,
				Выборка.АлкогольнаяПродукцияСерия,
				Выборка.АлкогольнаяПродукция);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки, 
				ЭтотОбъект, 
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сырьё", Выборка.НомерСтроки, "АлкогольнаяПродукция")
				, 
				, 
				Отказ);	
		КонецЕсли;
	КонецЦикла;      
	Возврат Результат;
КонецФункции

Процедура ЗарегистрироватьСоответствиеНоменклатурыЕГАИС(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТовар Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТовар.Справка2) Тогда
			Продолжить;
		КонецЕсли;
		
		СоответствиеНоменклатурыЕГАИС = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьМенеджерЗаписи();
		СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = СтрокаТовар.АлкогольнаяПродукция;
		СоответствиеНоменклатурыЕГАИС.Номенклатура         = СтрокаТовар.Номенклатура;
		СоответствиеНоменклатурыЕГАИС.Характеристика       = СтрокаТовар.Характеристика;
		СоответствиеНоменклатурыЕГАИС.Серия                = СтрокаТовар.Серия;
		СоответствиеНоменклатурыЕГАИС.Справка2             = СтрокаТовар.Справка2;
		СоответствиеНоменклатурыЕГАИС.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииЭтапаПроизводства(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапПроизводства2_2ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	МАКСИМУМ(СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция) КАК АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция.Крепость КАК Крепость
	|ПОМЕСТИТЬ ВТ_АП
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ЭтапПроизводства2_2ВыходныеИзделия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ЭтапПроизводства2_2ВыходныеИзделия.Номенклатура = СоответствиеНоменклатурыЕГАИС.Номенклатура
	|ГДЕ
	|	ЭтапПроизводства2_2ВыходныеИзделия.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЭтапПроизводства2_2ВыходныеИзделия.Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция.Крепость
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапПроизводства2_2.Организация КАК Организация,
	|	ЕСТЬNULL(КлассификаторОрганизацийЕГАИСОрганизация.Ссылка, НЕОПРЕДЕЛЕНО) КАК ОрганизацияЕГАИС,
	|	ЭтапПроизводства2_2.Ссылка КАК ДокументОснование,
	|	ЭтапПроизводства2_2.ДатаПроизводства КАК ДатаПроизводства,
	|	ЭтапПроизводства2_2.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИСОрганизация
	|		ПО ЭтапПроизводства2_2.Организация = КлассификаторОрганизацийЕГАИСОрганизация.Контрагент
	|ГДЕ
	|	ЭтапПроизводства2_2.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапПроизводства2_2ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ЭтапПроизводства2_2ВыходныеИзделия.Серия КАК Серия,
	|	ЭтапПроизводства2_2ВыходныеИзделия.Характеристика КАК Характеристика,
	|	ЭтапПроизводства2_2ВыходныеИзделия.Количество КАК Количество,
	|	ЭтапПроизводства2_2ВыходныеИзделия.Серия.бг_НомерСертифицированнойПартии КАК НомерПартии,
	|	ЕСТЬNULL(ВТ_АП.АлкогольнаяПродукция, НЕОПРЕДЕЛЕНО) КАК АлкогольнаяПродукция,
	|	ЕСТЬNULL(ВТ_АП.Крепость, 0) КАК Крепость,
	|	ЕСТЬNULL(ВТ_АП.Крепость, 0) КАК КрепостьМин,
	|	ЕСТЬNULL(ВТ_АП.Крепость, 0) КАК КрепостьМакс
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ЭтапПроизводства2_2ВыходныеИзделия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_АП КАК ВТ_АП
	|		ПО ЭтапПроизводства2_2ВыходныеИзделия.Номенклатура = ВТ_АП.Номенклатура
	|ГДЕ
	|	ЭтапПроизводства2_2ВыходныеИзделия.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапПроизводства2_2РасходМатериаловИРабот.Номенклатура КАК Номенклатура,
	|	ЭтапПроизводства2_2РасходМатериаловИРабот.Характеристика КАК Характеристика,
	|	СерииНоменклатуры.Справка2ЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ЭтапПроизводства2_2РасходМатериаловИРабот.Серия КАК Серия,
	|	СерииНоменклатуры.бг_ФактическаяКрепость КАК Крепость,
	|	СерииНоменклатуры.ПроизводительЕГАИС КАК Производитель,
	|	ЭтапПроизводства2_2РасходМатериаловИРабот.Количество КАК Количество,
	|	СерииНоменклатуры.Справка2ЕГАИС КАК Справка2
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.РасходМатериаловИРабот КАК ЭтапПроизводства2_2РасходМатериаловИРабот
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|		ПО ЭтапПроизводства2_2РасходМатериаловИРабот.Серия = СерииНоменклатуры.Ссылка
	|ГДЕ
	|	СерииНоменклатуры.Справка2ЕГАИС <> ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.ПустаяСсылка)
	|	И ЭтапПроизводства2_2РасходМатериаловИРабот.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаШапка = Результат[1].Выбрать();
	ВыборкаТовары = Результат[2].Выбрать();
	ВыборкаСырьё = Результат[3].Выбрать();
	
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	КонецЕсли;
	
	Товары.Очистить();
	Сырьё.Очистить();
	
	Пока ВыборкаТовары.Следующий() Цикл
		НовСтрокаТовары = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрокаТовары, ВыборкаТовары);
	КонецЦикла;
	
	Пока ВыборкаСырьё.Следующий() Цикл
		НовСтрокаСырьё = Сырьё.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрокаСырьё, ВыборкаСырьё);
	КонецЦикла;

КонецПроцедуры

Процедура ОтразитьДвиженияМарок(ДополнительныеСвойства, Движения) 
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.Таблицабг_ДвижениеМарок;
	
	Если Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияБг_ДвижениеМарок = Движения.бг_ДвижениеМарок;
	ДвиженияБг_ДвижениеМарок.Записывать = Истина;
	ДвиженияБг_ДвижениеМарок.Загрузить(Таблица);
	
КонецПроцедуры

Процедура ПроверитьДублированиеОтчетаОПроизводстве(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетОПроизводствеЕГАИС.Номер КАК Номер,
	|	ОтчетОПроизводствеЕГАИС.Дата КАК Дата,
	|	ОтчетОПроизводствеЕГАИС.ДокументОснование.Номер КАК ДокументОснованиеНомер,
	|	ОтчетОПроизводствеЕГАИС.ДокументОснование.Дата КАК ДокументОснованиеДата
	|ИЗ
	|	Документ.битОтчетОПроизводствеЕГАИС КАК ОтчетОПроизводствеЕГАИС
	|ГДЕ
	|	ОтчетОПроизводствеЕГАИС.ДокументОснование = &ДокументОснование
	|	И ОтчетОПроизводствеЕГАИС.Проведен
	|	И НЕ ОтчетОПроизводствеЕГАИС.Ссылка = &ТекущийДокумент";
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Для этапа производства %1 от %2 сформирован отчет о производстве ЕГАИС %3 от %4. Проведение документа невозможно'");
		ТекстСообщения = СтрШаблон(ТекстСообщения,
									Выборка.ДокументОснованиеНомер,
									Формат(Выборка.ДокументОснованиеДата, "ДФ=dd.MM.yyyy"),
									Выборка.Номер,
									Формат(Выборка.Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
