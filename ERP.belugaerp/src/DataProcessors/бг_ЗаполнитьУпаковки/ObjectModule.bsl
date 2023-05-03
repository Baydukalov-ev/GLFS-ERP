#Область ПрограммныйИнтерфейс

Процедура ВыполнитьКоманду(ИмяКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
	
	Если ИмяКоманды = "ЗаполнитьУпаковки" Тогда
		
		ВызовИзФормыДокумента = Истина;
		ЗаполнитьУпаковкиВФормеДокумента(ПараметрыВыполнения.ЭтаФорма);
		
	ИначеЕсли ИмяКоманды = "ЗаполнитьУпаковкиВДокументах" Тогда
		
		ВызовИзФормыДокумента = Ложь;
		ЗаполнитьУпаковкиВДокументах(ОбъектыНазначения, ПараметрыВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьУпаковкиВДокументе(ДокументОбъект) Экспорт
	
	ОтгружатьВЗаказеТолькоОднуПартию =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОбъект.Контрагент, "бг_ОтгружатьВЗаказеТолькоОднуПартию");
	
	Товары = ДокументОбъект.Товары;
	тзТовары = Товары.Выгрузить();
	
	РеквизитыПаллетизации = бг_УпаковкиЕдиницыИзмерения.ВсеРеквизитыПаллетизации();
	Для Каждого ОписаниеРеквизита Из РеквизитыПаллетизации Цикл
		тзТовары.Колонки.Добавить(ОписаниеРеквизита.Имя, ОписаниеРеквизита.Тип);
	КонецЦикла;
	
	ЗаполнитьДанныеУпаковок(тзТовары);
	
	СписокНоменклатуры = тзТовары.ВыгрузитьКолонку("Номенклатура");
	
	ОстаткиПоУпаковкам = ОстаткиПоУпаковкам(
		ДокументОбъект.Дата,
		ДокументОбъект.Организация,
		СписокНоменклатуры,
		ДокументОбъект.Склад,
		ДокументОбъект.Партнер);
	
	УпаковкиПоУмолчанию = УпаковкиПоУмолчанию(СписокНоменклатуры);
	
	ЗаполнитьУпаковкиВТЧ(тзТовары, ОстаткиПоУпаковкам, УпаковкиПоУмолчанию);
	
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТаблицыТоваров(тзТовары);
	
	Товары.Загрузить(тзТовары);
	
	ЗаказыСервер.УстановитьКлючВСтрокахТабличнойЧасти(ДокументОбъект, "Товары");
	бг_УпаковкиЕдиницыИзмерения.РассчитатьИтоговыеПоказателиПаллетизации(ДокументОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьУпаковкиВФормеДокумента(ФормаДокумента)
	
	ОтгружатьВЗаказеТолькоОднуПартию =
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФормаДокумента.Объект.Контрагент, "бг_ОтгружатьВЗаказеТолькоОднуПартию");
	
	Товары = ФормаДокумента.Объект.Товары;
	тзТовары = Товары.Выгрузить();
	
	СписокНоменклатуры = тзТовары.ВыгрузитьКолонку("Номенклатура");
	
	ОстаткиПоУпаковкам = ОстаткиПоУпаковкам(
		ФормаДокумента.Объект.Дата,
		ФормаДокумента.Объект.Организация,
		СписокНоменклатуры,
		ФормаДокумента.Объект.Склад,
		ФормаДокумента.Объект.Партнер);
	
	УпаковкиПоУмолчанию = УпаковкиПоУмолчанию(СписокНоменклатуры);
	
	ЗаполнитьУпаковкиВТЧ(тзТовары, ОстаткиПоУпаковкам, УпаковкиПоУмолчанию);
	
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТаблицыТоваров(тзТовары);
	
	Товары.Загрузить(тзТовары);
	
	РассчитатьИтоговыеПоказателиЗаказа(ФормаДокумента);
	
	ЗаказыСервер.УстановитьКлючВСтрокахТабличнойЧасти(ФормаДокумента.Объект, "Товары");
	бг_УпаковкиЕдиницыИзмерения.РассчитатьИтоговыеПоказателиПаллетизации(ФормаДокумента.Объект);
	
	ФормаДокумента.Модифицированность = Истина;
	
КонецПроцедуры
	
Процедура ЗаполнитьУпаковкиВДокументах(ОбъектыНазначения, ПараметрыВыполнения)
	
	Для каждого ДокументСсылка Из ОбъектыНазначения Цикл
		
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ЗаполнитьУпаковкиВДокументе(ДокументОбъект);
		
		Попытка
			лРежимЗаписиДокумента = ?(ДокументСсылка.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
			ДокументОбъект.Записать(лРежимЗаписиДокумента);
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Ошибка при заполнении упаковок в документе %1'"), ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ДокументСсылка, , "Этаформа");
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОстаткиПоУпаковкам(ДатаДокумента, Организация, СписокНоменклатуры, Склад, Партнер)
	
	Запрос = Новый Запрос;
	
	Если ОтгружатьВЗаказеТолькоОднуПартию Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КлючиАналитикиУчетаНоменклатуры.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ КлючиАналитикиНоменклатуры
		|ИЗ
		|	Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
		|ГДЕ
		|	КлючиАналитикиУчетаНоменклатуры.Номенклатура В(&СписокНоменклатуры)
		|	И КлючиАналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)
		|	И КлючиАналитикиУчетаНоменклатуры.МестоХранения = &Склад
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия.бг_УпаковкаПаллета КАК Упаковка,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия.бг_УпаковкаПаллета, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК УпаковкаЗаполнена,
		|	ЛОЖЬ КАК ПриоритетнаяУпаковка,
		|	ТоварыОрганизацийОстатки.КоличествоОстаток КАК Свободно,
		|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизаций.Остатки(
		|			&Период,
		|			Организация = &Организация
		|				И АналитикаУчетаНоменклатуры В
		|					(ВЫБРАТЬ
		|						Т.Ссылка
		|					ИЗ
		|						КлючиАналитикиНоменклатуры КАК Т)) КАК ТоварыОрганизацийОстатки
		|ГДЕ
		|	ТоварыОрганизацийОстатки.КоличествоОстаток > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	КоличествоОстаток УБЫВ,
		|	Номенклатура,
		|	Серия";
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	НоменклатураКонтрагентов.Номенклатура КАК Номенклатура,
		|	НоменклатураКонтрагентов.Упаковка КАК Упаковка
		|ПОМЕСТИТЬ НоменклатураКонтрагентов
		|ИЗ
		|	Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
		|ГДЕ
		|	НоменклатураКонтрагентов.Владелец = &Контрагент
		|	И НоменклатураКонтрагентов.Номенклатура В(&СписокНоменклатуры)
		|	И НоменклатураКонтрагентов.Упаковка.ЕдиницаИзмерения = &ЕдиницаИзмерения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НоменклатураКонтрагентов.Номенклатура КАК Номенклатура,
		|	НоменклатураКонтрагентов.Упаковка КАК Упаковка,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(НоменклатураКонтрагентов.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК УпаковкаЗаполнена,
		|	ИСТИНА КАК ПриоритетнаяУпаковка,
		|	0 КАК Свободно,
		|	NULL КАК Серия
		|ИЗ
		|	НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	РаспределениеЗапасов.Номенклатура,
		|	РаспределениеЗапасов.Характеристика.бг_УпаковкаПаллета,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(РаспределениеЗапасов.Характеристика.бг_УпаковкаПаллета, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ЛОЖЬ,
		|	РаспределениеЗапасов.Свободно,
		|	NULL
		|ИЗ
		|	РегистрСведений.РаспределениеЗапасов КАК РаспределениеЗапасов
		|ГДЕ
		|	РаспределениеЗапасов.Склад = &Склад
		|	И РаспределениеЗапасов.Номенклатура В(&СписокНоменклатуры)
		|	И НЕ РаспределениеЗапасов.Номенклатура В
		|				(ВЫБРАТЬ
		|					НоменклатураКонтрагентов.Номенклатура
		|				ИЗ
		|					НоменклатураКонтрагентов КАК НоменклатураКонтрагентов)
		|	И РаспределениеЗапасов.Свободно > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриоритетнаяУпаковка УБЫВ,
		|	УпаковкаЗаполнена УБЫВ,
		|	Свободно УБЫВ";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Период",  ?(ЗначениеЗаполнено(ДатаДокумента), ДатаДокумента, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Контрагент",  Партнер);
	Запрос.УстановитьПараметр("Склад",  Склад);
	Запрос.УстановитьПараметр("СписокНоменклатуры",  СписокНоменклатуры);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЭтотОбъект.ЕдиницаПаллеты);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция УпаковкиПоУмолчанию(Номенклатура)
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	УпаковкиЕдиницыИзмерения.Владелец КАК Номенклатура,
		|	МИНИМУМ(УпаковкиЕдиницыИзмерения.Ссылка) КАК УпаковкаПоУмолчанию
		|ИЗ
		|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
		|ГДЕ
		|	УпаковкиЕдиницыИзмерения.Владелец В(&Номенклатура)
		|	И УпаковкиЕдиницыИзмерения.ЕдиницаИзмерения = &ЕдиницаИзмерения
		|
		|СГРУППИРОВАТЬ ПО
		|	УпаковкиЕдиницыИзмерения.Владелец";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЭтотОбъект.ЕдиницаПаллеты);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(ВыборкаДетальныеЗаписи.Номенклатура, ВыборкаДетальныеЗаписи.УпаковкаПоУмолчанию);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьУпаковкиВТЧ(тзТовары, ОстаткиПоУпаковкам, УпаковкиПоУмолчанию)
	
	Для к = 1 По тзТовары.Количество() Цикл
		Строка = тзТовары[к-1];
		
		// Если в строке заказа уже заполнена упаковка - пропускаем заполнение упаковки
		Если ЗначениеЗаполнено(Строка.бг_УпаковкаПаллета) Тогда
			Продолжить;
		КонецЕсли;
		
		// Если есть приоритетная упаковка - устанавливаем приоритетную упаковку
		СтрокиПриоритетнаяУпаковка = ОстаткиПоУпаковкам.НайтиСтроки(
			Новый Структура("Номенклатура, ПриоритетнаяУпаковка", Строка.Номенклатура, Истина));
		
		Если СтрокиПриоритетнаяУпаковка.Количество() Тогда
			Строка.бг_УпаковкаПаллета = СтрокиПриоритетнаяУпаковка[0].Упаковка;
			Продолжить;
		КонецЕсли;
		
		// Если приоритетной упаковки нет - подбираем упаковки по остаткам
		СтрокиСОстатками = ОстаткиПоУпаковкам.НайтиСтроки(
			Новый Структура("Номенклатура, ПриоритетнаяУпаковка", Строка.Номенклатура, Ложь));
		
		Если СтрокиСОстатками.Количество() = 0 Тогда
			
			Строка.бг_УпаковкаПаллета = УпаковкиПоУмолчанию.Получить(Строка.Номенклатура);
			ПересчитатьДанныеВСтроке(Строка);
			Продолжить;
		ИначеЕсли СтрокиСОстатками.Количество() = 1 Тогда
			
			Строка.бг_УпаковкаПаллета = СтрокиСОстатками[0].Упаковка;
			Если Не ЗначениеЗаполнено(Строка.бг_УпаковкаПаллета) Тогда
				Строка.бг_УпаковкаПаллета = УпаковкиПоУмолчанию.Получить(Строка.Номенклатура);
			КонецЕсли;
			ПересчитатьДанныеВСтроке(Строка);
			Продолжить;
		ИначеЕсли ОтгружатьВЗаказеТолькоОднуПартию Тогда
			
			// Упаковки с остатками уже отсортированы в результате запроса по убыванию количества
			// поэтому выбираем первую упаковку из результата
			Строка.бг_УпаковкаПаллета = СтрокиСОстатками[0].Упаковка;
			Если Не ЗначениеЗаполнено(Строка.бг_УпаковкаПаллета) Тогда
				Строка.бг_УпаковкаПаллета = УпаковкиПоУмолчанию.Получить(Строка.Номенклатура);
			КонецЕсли;
			ПересчитатьДанныеВСтроке(Строка);
			Продолжить;
		Иначе
			
			НераспределенноеКоличество = Строка.Количество;
			
			УпаковкаПоУмолчанию = СтрокиСОстатками[0].Упаковка;
			Если Не ЗначениеЗаполнено(УпаковкаПоУмолчанию) Тогда
				УпаковкаПоУмолчанию = УпаковкиПоУмолчанию.Получить(Строка.Номенклатура);
			КонецЕсли;
			
			Для каждого СтрокаОстатка Из СтрокиСОстатками Цикл
				
				Если СтрокаОстатка.Свободно < Строка.Количество Тогда
					
					НоваяСтрока = тзТовары.Добавить();
					ИсключаяСвойства = "КодСтроки";
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , ИсключаяСвойства);
					
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы(
						ЗависимыеРеквизитыСтрокой(), "Количество");
					
					ОбработкаТабличнойЧастиКлиентСервер.ЗаполнитьСтруктуруПересчетаСуммы(СтруктураПересчетаСуммы, Строка);
					
					НоваяСтрока.Количество = СтрокаОстатка.Свободно;
					НоваяСтрока.бг_УпаковкаПаллета = СтрокаОстатка.Упаковка;
					Строка.Количество = Строка.Количество - НоваяСтрока.Количество;
					
					НераспределенноеКоличество = НераспределенноеКоличество - СтрокаОстатка.Свободно;
					
					ОбработкаТабличнойЧастиКлиентСервер.ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, Строка);
					ОбработкаТабличнойЧастиКлиентСервер.ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, НоваяСтрока);
					ОбработкаТабличнойЧастиКлиентСервер.ПересчитатьСуммы(СтруктураПересчетаСуммы);
					
					ОстаткиПоУпаковкам.Удалить(СтрокаОстатка);
					СтрокиСОстатками = ОстаткиПоУпаковкам.НайтиСтроки(Новый Структура("Номенклатура", Строка.Номенклатура));
					
					ПересчитатьДанныеВСтроке(НоваяСтрока);
					
				Иначе
					
					Строка.бг_УпаковкаПаллета = СтрокаОстатка.Упаковка;
					СтрокаОстатка.Свободно = СтрокаОстатка.Свободно - Строка.Количество;
					НераспределенноеКоличество = 0;
					
				КонецЕсли;
				
				ПересчитатьДанныеВСтроке(Строка);
				
				Если НераспределенноеКоличество <= 0 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(Строка.бг_УпаковкаПаллета) Тогда
				Строка.бг_УпаковкаПаллета = УпаковкаПоУмолчанию;
				ПересчитатьДанныеВСтроке(Строка);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗависимыеРеквизитыСтрокой()
	
	СписокРеквизитов = "бг_КоличествоКоробок, бг_КоличествоПаллет, бг_СуммаПримененнойСкидки, " + 
		"КоличествоУпаковок, Сумма, СуммаНДС, СуммаСНДС, СуммаРучнойСкидки";	
	
	Если ВызовИзФормыДокумента Тогда
		СписокРеквизитов = СписокРеквизитов + ", 
			|СуммаБезВозвратнойТары, СуммаНДСБезВозвратнойТары, СуммаСНДСБезВозвратнойТары,
			|СуммаРучнойСкидкиБезВозвратнойТары, СуммаАвтоматическойСкидкиБезВозвратнойТары,
			|СуммаОтмененоБезВозвратнойТары, СуммаНДСОтмененоБезВозвратнойТары, СуммаСНДСОтмененоБезВозвратнойТары,
			|СуммаРучнойСкидкиОтмененоБезВозвратнойТары, СуммаАвтоматическойСкидкиОтмененоБезВозвратнойТары,
			|СуммаОтменено, СуммаНДСОтменено, СуммаСНДСОтменено,
			|СуммаРучнойСкидкиОтменено, СуммаАвтоматическойСкидкиОтменено";
	КонецЕсли;
	
	Возврат СписокРеквизитов;
	
КонецФункции

Процедура ЗаполнитьДанныеУпаковок(тзТовары)
	
	ЗаполнитьЕдиницыУпаковок();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТоваров", тзТовары);
	Запрос.УстановитьПараметр("ЕдиницаКоробки", ЭтотОбъект.ЕдиницаКоробки);
	Запрос.УстановитьПараметр("ЕдиницаПаллеты", ЭтотОбъект.ЕдиницаПаллеты);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.Номенклатура КАК Номенклатура,
	|	ДанныеДокумента.Упаковка КАК Упаковка,
	|	ДанныеДокумента.бг_УпаковкаПаллета КАК УпаковкаПаллета
	|ПОМЕСТИТЬ втДанныеДокумента
	|ИЗ
	|	&ТаблицаТоваров КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеДокумента.НомерСтроки КАК НомерСтроки,
	|	втДанныеДокумента.Номенклатура КАК Номенклатура,
	|	втДанныеДокумента.Упаковка КАК Упаковка,
	|	ЕСТЬNULL(КонечныеУпаковки.Упаковка, втДанныеДокумента.Упаковка) КАК КонечнаяУпаковка,
	|	втДанныеДокумента.УпаковкаПаллета КАК УпаковкаПаллета
	|ПОМЕСТИТЬ втДанныеУпаковокДокумента
	|ИЗ
	|	втДанныеДокумента КАК втДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			УпаковкиЕдиницыИзмерения.Ссылка КАК Упаковка,
	|			УпаковкиЕдиницыИзмерения.Владелец КАК Номенклатура
	|		ИЗ
	|			Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|		ГДЕ
	|			УпаковкиЕдиницыИзмерения.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.Конечная)) КАК КонечныеУпаковки
	|		ПО (втДанныеДокумента.Номенклатура = КонечныеУпаковки.Номенклатура)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеУпаковокДокумента.НомерСтроки КАК НомерСтроки,
	|	втДанныеУпаковокДокумента.Номенклатура КАК Номенклатура,
	|	втДанныеУпаковокДокумента.Упаковка КАК Упаковка,
	|	втДанныеУпаковокДокумента.КонечнаяУпаковка КАК КонечнаяУпаковка,
	|	втДанныеУпаковокДокумента.УпаковкаПаллета КАК УпаковкаПаллета,
	|	втДанныеУпаковокДокумента.Номенклатура.ОбъемДАЛ КАК бг_ОбъемДАЛЕд,
	|	&ТекстЗапросаВесУпаковкиБрутто КАК бг_ВесУпаковкиБрутто,
	|	&ТекстЗапросаОбъемУпаковкиБрутто КАК бг_ОбъемУпаковкиБрутто,
	|	&ТекстЗапросаОбъемУпаковки КАК бг_ОбъемУпаковки,
	|	&ТекстЗапросаВесУпаковки КАК бг_ВесУпаковки,
	|	ВЫБОР 
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаКоробки
	|			ТОГДА &ТекстЗапросаКоэффициентаУпаковки
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаПаллеты
	|			ТОГДА ЕСТЬNULL(СоставныеУпаковки.КоличествоЕдиниц, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК бг_КоэффициентКоробки,
	|	ВЫБОР 
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаПаллеты
	|			ТОГДА &ТекстЗапросаКоэффициентаУпаковки
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаКоробки
	|			ТОГДА ЕСТЬNULL(СоставныеУпаковки.КоличествоЕдиниц, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК бг_КоэффициентПаллеты,
	|	ВЫБОР 
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаКоробки
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК бг_ЭтоКоробка,
	|	ВЫБОР 
	|		КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаПаллеты
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК бг_ЭтоПаллета
	|ИЗ
	|	втДанныеУпаковокДокумента КАК втДанныеУпаковокДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			УпаковкиЕдиницыИзмерения.Ссылка КАК Упаковка,
	|			УпаковкиЕдиницыИзмерения.Числитель КАК КоличествоЕдиниц
	|		ИЗ
	|			Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|		ГДЕ
	|			УпаковкиЕдиницыИзмерения.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.Составная)) КАК СоставныеУпаковки	
	|		ПО (ВЫБОР
	|				КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаКоробки
	|					ТОГДА втДанныеУпаковокДокумента.УпаковкаПаллета = СоставныеУпаковки.Упаковка.Родитель
	|				КОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.ЕдиницаИзмерения = &ЕдиницаПаллеты
	|					ТОГДА втДанныеУпаковокДокумента.УпаковкаПаллета.Родитель = СоставныеУпаковки.Упаковка
	|			КОНЕЦ)";
	
	Запрос.Текст = СтрЗаменить(
					Запрос.Текст, 
					"&ТекстЗапросаВесУпаковкиБрутто",
					Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("втДанныеУпаковокДокумента.УпаковкаПаллета", 
						"втДанныеУпаковокДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
					Запрос.Текст, 
					"&ТекстЗапросаОбъемУпаковкиБрутто",
					Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("втДанныеУпаковокДокумента.УпаковкаПаллета", 
						"втДанныеУпаковокДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
					Запрос.Текст, 
					"&ТекстЗапросаОбъемУпаковки",
					Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("втДанныеУпаковокДокумента.КонечнаяУпаковка", 
						"втДанныеУпаковокДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
					Запрос.Текст, 
					"&ТекстЗапросаВесУпаковки",
					Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("втДанныеУпаковокДокумента.КонечнаяУпаковка", 
						"втДанныеУпаковокДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
					Запрос.Текст, 
					"&ТекстЗапросаКоэффициентаУпаковки",
					Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("втДанныеУпаковокДокумента.УпаковкаПаллета", 
						"втДанныеУпаковокДокумента.Номенклатура"));
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	Если ТаблицаРезультата.Количество() > 0 Тогда
		Для каждого СтрокаТовары Из тзТовары Цикл
			ДанныеУпаковки = ТаблицаРезультата.Найти(СтрокаТовары.НомерСтроки, "НомерСтроки");
			Если ДанныеУпаковки <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(
					СтрокаТовары, 
					ДанныеУпаковки, 
					"бг_ВесУпаковки, бг_ВесУпаковкиБрутто, бг_ОбъемУпаковки, бг_ОбъемУпаковкиБрутто, 
					|бг_КоэффициентКоробки, бг_КоэффициентПаллеты, бг_ОбъемДАЛЕд");
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПересчитатьДанныеВСтроке(Строка)
	
	Если ЗначениеЗаполнено(Строка.Номенклатура)
		И ЗначениеЗаполнено(Строка.бг_УпаковкаПаллета) Тогда
		
		ДанныеУпаковки = ДанныеУпаковки(Строка.Номенклатура, Строка.бг_УпаковкаПаллета);
							
		Строка.бг_КоэффициентКоробки = ДанныеУпаковки.КоэффициентКоробки;
		Строка.бг_КоэффициентПаллеты = ДанныеУпаковки.КоэффициентПаллеты;
		Строка.бг_ВесУпаковкиБрутто = ДанныеУпаковки.Вес;
		Строка.бг_ОбъемУпаковкиБрутто = ДанныеУпаковки.Объем;
		
		Если Строка.КоличествоУпаковок > 0 Тогда
			
			Если Строка.бг_КоэффициентКоробки > 0 Тогда
				Строка.бг_КоличествоКоробок = Строка.КоличествоУпаковок / Строка.бг_КоэффициентКоробки;
			Иначе
				Строка.бг_КоличествоКоробок = 0;
			КонецЕсли;
			
			Если Строка.бг_КоэффициентПаллеты > 0 Тогда
				Строка.бг_КоличествоПаллет = Строка.КоличествоУпаковок / Строка.бг_КоэффициентПаллеты;
			Иначе
				Строка.бг_КоличествоПаллет = 0;
			КонецЕсли;
		Иначе 
			Строка.бг_КоличествоКоробок = 0;
			Строка.бг_КоличествоПаллет = 0;
		КонецЕсли;
		
	Иначе
		
		Строка.бг_КоличествоКоробок = 0;
		Строка.бг_КоличествоПаллет = 0;
		Строка.бг_КоэффициентКоробки = 0;
		Строка.бг_КоэффициентПаллеты = 0;
		Строка.бг_ВесУпаковкиБрутто = 0;
		Строка.бг_ОбъемУпаковкиБрутто = 0;
		
	КонецЕсли;

КонецПроцедуры

Функция ДанныеУпаковки(Номенклатура, Упаковка)
	
	ДанныеУпаковки = Новый Структура("Вес, Объем, КоэффициентКоробки, КоэффициентПаллеты", 0, 0, 0, 0);
	
	ТипУпаковки = ТипУпаковки(Упаковка);
	Если ТипУпаковки.ЭтоПаллета Тогда
		Коэффициенты = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(
							Упаковка, 
							Номенклатура); 
			
		ДанныеУпаковки.КоэффициентПаллеты = Коэффициенты.Коэффициент;
		ДанныеУпаковки.Вес = Коэффициенты.Вес;
		ДанныеУпаковки.Объем = Коэффициенты.Объем; 
		
		Коэффициенты = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(
							ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Упаковка, "Родитель"), 
							Номенклатура);
							
		ДанныеУпаковки.КоэффициентКоробки = Коэффициенты.Коэффициент;
	ИначеЕсли ТипУпаковки.ЭтоКоробка Тогда
		Коэффициенты = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(
							Упаковка, 
							Номенклатура);
			
		ДанныеУпаковки.КоэффициентКоробки = Коэффициенты.Коэффициент;
		ДанныеУпаковки.Вес = Коэффициенты.Вес;
		ДанныеУпаковки.Объем = Коэффициенты.Объем;

		УпаковкаПаллета = УпаковкаПоРодителю(Упаковка);
		Если УпаковкаПаллета <> Неопределено Тогда
			Коэффициенты = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(
								УпаковкаПаллета, 
								Номенклатура);
								
			ДанныеУпаковки.КоэффициентПаллеты = Коэффициенты.Коэффициент;
		КонецЕсли;
	Иначе 
		Коэффициенты = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентВесОбъемПрочиеРеквизитыУпаковки(
							КонечнаяУпаковкаНоменклатуры(Номенклатура), 
							Номенклатура);
							
		ДанныеУпаковки.Вес = Коэффициенты.Вес;
		ДанныеУпаковки.Объем = Коэффициенты.Объем;
	КонецЕсли;
	
	Возврат ДанныеУпаковки;
	
КонецФункции

Функция ТипУпаковки(Упаковка)
	
	ТипУпаковки = Новый Структура("ЭтоПаллета, ЭтоКоробка", Ложь, Ложь);
	
	ЕдиницаИзмеренияУпаковки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Упаковка, "ЕдиницаИзмерения");
	
	Если ЕдиницаИзмеренияУпаковки = ЭтотОбъект.ЕдиницаПаллеты Тогда
		ТипУпаковки.ЭтоПаллета = Истина;
	ИначеЕсли ЕдиницаИзмеренияУпаковки = ЭтотОбъект.ЕдиницаКоробки Тогда
		ТипУпаковки.ЭтоКоробка = Истина;
	КонецЕсли;
		
	Возврат ТипУпаковки;
	
КонецФункции

Функция УпаковкаПоРодителю(Упаковка)
	
	Выборка = Справочники.УпаковкиЕдиницыИзмерения.Выбрать(Упаковка);
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция КонечнаяУпаковкаНоменклатуры(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиЕдиницыИзмерения.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмерения
	|ГДЕ
	|	УпаковкиЕдиницыИзмерения.Владелец = &Владелец
	|	И УпаковкиЕдиницыИзмерения.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.Конечная)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения");
	КонецЕсли;
	
КонецФункции

Процедура РассчитатьИтоговыеПоказателиЗаказа(Форма)
	
	// Заполнение итогов по таблице "Товары"
	КоллекцияТовары = Форма.Объект.Товары;

	Форма.СуммаЗаказаноСЗалоговойТарой = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		КоллекцияТовары.Итог("СуммаСНДС") - КоллекцияТовары.Итог("СуммаСНДСОтменено"),
		КоллекцияТовары.Итог("СуммаСНДСБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаСНДСОтмененоБезВозвратнойТары"));
	Форма.СуммаЗаказано     = КоллекцияТовары.Итог("СуммаСНДСБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаСНДСОтмененоБезВозвратнойТары");
	Форма.СуммаЗалогаЗаТару = ?(Форма.Объект.ТребуетсяЗалогЗаТару,(КоллекцияТовары.Итог("СуммаСНДС") - КоллекцияТовары.Итог("СуммаСНДСОтменено"))
			- (КоллекцияТовары.Итог("СуммаСНДСБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаСНДСОтмененоБезВозвратнойТары")),0);
	Форма.СуммаНДСЗаказано  = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		КоллекцияТовары.Итог("СуммаНДС") - КоллекцияТовары.Итог("СуммаНДСОтменено"),
		КоллекцияТовары.Итог("СуммаНДСБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаНДСОтмененоБезВозвратнойТары"));
		
	СуммаАвтоСкидки   = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		КоллекцияТовары.Итог("СуммаАвтоматическойСкидки") - КоллекцияТовары.Итог("СуммаАвтоматическойСкидкиОтменено"),
		КоллекцияТовары.Итог("СуммаАвтоматическойСкидкиБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаАвтоматическойСкидкиОтмененоБезВозвратнойТары"));
	СуммаРучнойСкидки = ?(Форма.Объект.ТребуетсяЗалогЗаТару,
		КоллекцияТовары.Итог("СуммаРучнойСкидки") - КоллекцияТовары.Итог("СуммаРучнойСкидкиОтменено"),
		КоллекцияТовары.Итог("СуммаРучнойСкидкиБезВозвратнойТары") - КоллекцияТовары.Итог("СуммаРучнойСкидкиОтмененоБезВозвратнойТары"));
	Форма.СуммаСкидки       = СуммаАвтоСкидки + СуммаРучнойСкидки;
	
	Если КоллекцияТовары.Итог("СуммаСНДСОтменено") = КоллекцияТовары.Итог("СуммаСНДС") Тогда
		Форма.ВсеСтрокиОтменены = Истина;
	Иначе
		Форма.ВсеСтрокиОтменены = Ложь;
	КонецЕсли;
	
	// Выбор странцицы отображения НДС
	ОтображатьИтогСуммыНДС = УчетНДСУПКлиентСервер.ОтображатьНДСВИтогахДокументаПродажи(Форма.Объект.НалогообложениеНДС);
	
	Если ОтображатьИтогСуммыНДС Тогда
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДС;
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница = Форма.Элементы.СтраницаСНДС;
	Иначе
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДС;
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница = Форма.Элементы.СтраницаБезНДС;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЕдиницыУпаковок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УпаковкиПаллеты.Ссылка КАК ЕдиницаПаллеты,
	|	УпаковкиКоробки.Ссылка КАК ЕдиницаКоробки
	|ИЗ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиКоробки,
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиПаллеты
	|ГДЕ
	|	УпаковкиКоробки.бг_ТипЕдиницыИзмерения = ЗНАЧЕНИЕ(Перечисление.бг_ТипыЕдиницИзмерения.Коробка)
	|	И УпаковкиПаллеты.бг_ТипЕдиницыИзмерения = ЗНАЧЕНИЕ(Перечисление.бг_ТипыЕдиницИзмерения.Паллета)";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

#КонецОбласти

ЗаполнитьЕдиницыУпаковок();
