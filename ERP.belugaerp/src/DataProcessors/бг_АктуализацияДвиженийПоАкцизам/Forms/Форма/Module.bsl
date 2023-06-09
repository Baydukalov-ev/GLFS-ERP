
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементовСогласноОперации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементовСогласноОперации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура АктуализироватьДвижения(Команда)
	АктуализироватьДвиженияНаСервере(Период.ДатаНачала, Период.ДатаОкончания, Организация,
											Номенклатура, СерияНоменклатуры, Сделка,
											Продукция, СерияПродукции);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаменуСделки(Команда)
	Если Не ЗначениеЗаполнено(Сделка)
		Или Не ЗначениеЗаполнено(СделкаЗамена) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить данные замены'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
		
	ВыполнитьЗаменуСделкиНаСервере(Сделка, СделкаЗамена, ПТУ);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДвижения(Команда)
	Если Не ЗначениеЗаполнено(ТипОбъектов) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбраны типы документов для которых требуется сформировать движения'"));
		Возврат;
	КонецЕсли;
	
	СформироватьДвиженияНаСервере(ТипОбъектов, Организация, Период.ДатаНачала, Период.ДатаОкончания);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДвиженияПоДням(Команда)
	СформироватьДвиженияПоДнямНаСервере(Организация, Период.ДатаНачала, Период.ДатаОкончания);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИфункции

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементовСогласноОперации()
	Если Операция = 0 Тогда
		Элементы.СтраницыОперации.ТекущаяСтраница = Элементы.СтраницаПересчетДвижений;
		Элементы.АктуализироватьДвижения.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Операция = 1 Тогда
		Элементы.СтраницыОперации.ТекущаяСтраница = Элементы.СтраницаЗаменаСделки;
		Элементы.ВыполнитьЗаменуСделки.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.СтраницыОперации.ТекущаяСтраница = Элементы.СтраницаФормированиеДвижений;
		Элементы.СформироватьДвижения.КнопкаПоУмолчанию = Истина;
		Элементы.ТипОбъектов.Видимость  = Операция = 2;
	КонецЕсли;
	
	Элементы.АктуализироватьДвижения.Видимость    = Операция = 0;
	Элементы.ВыполнитьЗаменуСделки.Видимость      = Операция = 1;
	Элементы.СформироватьДвижения.Видимость       = Операция = 2;
	Элементы.СформироватьДвиженияПоДням.Видимость = Операция = 3;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АктуализироватьДвиженияНаСервере(ДатаНачала, ДатаОкончания, Организация,
											Номенклатура, СерияНоменклатуры, Сделка,
											Продукция, СерияПродукции)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизПоПриобретеннымЦенностям.Организация КАК Организация,
	|	АкцизПоПриобретеннымЦенностям.Номенклатура КАК Номенклатура,
	|	АкцизПоПриобретеннымЦенностям.СерияНоменклатуры КАК СерияНоменклатуры,
	|	АкцизПоПриобретеннымЦенностям.Сделка КАК Сделка,
	|	АкцизПоПриобретеннымЦенностям.СостояниеСырья КАК СостояниеСырья,
	|	АкцизПоПриобретеннымЦенностям.СостояниеОплатыАванса КАК СостояниеОплатыАванса,
	|	АкцизПоПриобретеннымЦенностям.СтатусАкциза КАК СтатусАкциза,
	|	АкцизПоПриобретеннымЦенностям.Продукция КАК Продукция,
	|	АкцизПоПриобретеннымЦенностям.СерияПродукции КАК СерияПродукции
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностям КАК АкцизПоПриобретеннымЦенностям
	|ГДЕ
	|	АкцизПоПриобретеннымЦенностям.Период >= &НачалоПериода
	|	И (АкцизПоПриобретеннымЦенностям.Период <= &КонецПериода
	|			ИЛИ &КонецПериода = ДАТАВРЕМЯ(1, 1, 1))
	|	И (АкцизПоПриобретеннымЦенностям.Организация = &Организация
	|			ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|	И (АкцизПоПриобретеннымЦенностям.Номенклатура = &Номенклатура
	|			ИЛИ &Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|	И (АкцизПоПриобретеннымЦенностям.СерияНоменклатуры = &СерияНоменклатуры
	|			ИЛИ &СерияНоменклатуры = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))
	|	И (АкцизПоПриобретеннымЦенностям.Сделка = &Сделка
	|			ИЛИ &Сделка = НЕОПРЕДЕЛЕНО)
	|	И (АкцизПоПриобретеннымЦенностям.Продукция = &Продукция
	|			ИЛИ &Продукция = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|	И (АкцизПоПриобретеннымЦенностям.СерияПродукции = &СерияПродукции
	|			ИЛИ &СерияПродукции = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))";
	Запрос.УстановитьПараметр("НачалоПериода",     ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",      ДатаОкончания);
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("Номенклатура",      Номенклатура);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("Сделка",            ?(ЗначениеЗаполнено(Сделка), Сделка, Неопределено));
	Запрос.УстановитьПараметр("Продукция",         Продукция);
	Запрос.УстановитьПараметр("СерияПродукции",    СерияПродукции);
	Результат = Запрос.Выполнить();
	
	Обработки.бг_АктуализацияДвиженийПоАкцизам.ВосстановитьПоследовательностьДвижений(
		Результат.Выгрузить(),
		ДатаНачала,
		ДатаОкончания);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьЗаменуСделкиНаСервере(Сделка, СделкаЗамена, ПТУ)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Акциз.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.бг_АкцизПоПриобретеннымЦенностям КАК Акциз
	|ГДЕ
	|	Акциз.Сделка = &Сделка
	|	И (&Регистратор = НЕОПРЕДЕЛЕНО
	|			ИЛИ Акциз.Регистратор = &Регистратор)
	|	И НЕ ТИПЗНАЧЕНИЯ(Акциз.Регистратор) В (&ИсключаемыеТипыДокументов)";
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("Регистратор", ?(ЗначениеЗаполнено(ПТУ), ПТУ, Неопределено));
	Запрос.УстановитьПараметр("ИсключаемыеТипыДокументов", ИсключаемыеТипыДокументовЗаменаСделки());
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	НачатьТранзакцию();
	
	Попытка
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Регистратор);
			
			ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
			ЗаменитьСделку(ДокументОбъект, Сделка, СделкаЗамена);
			ЗаменитьСделкуДвижения(ДокументОбъект.Ссылка, Сделка, СделкаЗамена);
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ПТУ) Тогда
			ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПТУ, "Дата, Организация");
			АктуализироватьДвиженияНаСервере(ДанныеДокумента.Дата, '00010101', ДанныеДокумента.Организация,
								Справочники.Номенклатура.ПустаяСсылка(), Справочники.СерииНоменклатуры.ПустаяСсылка(), Сделка,
								Справочники.Номенклатура.ПустаяСсылка(), Справочники.СерииНоменклатуры.ПустаяСсылка());
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
		ТекстСообшения = СтрШаблон(НСтр("ru = 'Сделка замена в %1 документах'"), Выборка.Количество());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообшения);
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообшения = СтрШаблон(НСтр("ru = 'Не удалось заменить сделку в документе %1. %2'"), Выборка.РегистраторПредставление, ОписаниеОшибки());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообшения);
		
		ВызватьИсключение НСтр("ru = 'Не удалось выполнить замену сделки'");
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаменитьСделку(ДокументОбъект, Сделка, СделкаЗамена)
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	ИменаТабличныхЧастейАкцизы = Новый Массив;
	ИменаТабличныхЧастейАкцизы.Добавить("БанковскиеГарантии");
	ИменаТабличныхЧастейАкцизы.Добавить("бг_АкцизПоПриобретеннымЦенностям");
	ИменаТабличныхЧастейАкцизы.Добавить("бг_АкцизПоПриобретеннымЦенностямМатериалы");
	ИменаТабличныхЧастейАкцизы.Добавить("бг_АкцизПоПриобретеннымЦенностямПродукция");
	
	Для Каждого ИмяТабличнойЧасти Из ИменаТабличныхЧастейАкцизы Цикл
		Если МетаданныеДокумента.ТабличныеЧасти.Найти(ИмяТабличнойЧасти) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДокумента.ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты.Найти("Сделка") = Неопределено Тогда
			ИмяПоля = "БанковскаяГарантия";
		Иначе
			ИмяПоля = "Сделка";
		КонецЕсли;
		
		Отбор = Новый Структура(ИмяПоля, Сделка);
		СтрокиЗаменитьСделку = ДокументОбъект[ИмяТабличнойЧасти].НайтиСтроки(Отбор);
		Для Каждого СтрокаТабличнаяЧасть Из СтрокиЗаменитьСделку Цикл
			СтрокаТабличнаяЧасть[ИмяПоля] = СделкаЗамена;
		КонецЦикла;
	КонецЦикла;
	
	ВыполнитьДополнительныеОперацииЗаменаСделки(ДокументОбъект, Сделка, СделкаЗамена);
	ДокументОбъект.Записать();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьДополнительныеОперацииЗаменаСделки(ДокументОбъект, Сделка, СделкаЗамена)
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПриобретениеТоваровУслуг") Тогда
		ДокументОбъект.бг_ДиапазонБанковскихГарантий = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СделкаЗамена, "Родитель");
	Иначе
		ДокументОбъект.ДополнительныеСвойства.Вставить("адаптер_ЭтоГрупповаяОбработкаДанных", Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаменитьСделкуДвижения(Документ, Сделка, СделкаЗамена)
	НаборЗаписей = РегистрыНакопления.бг_АкцизПоПриобретеннымЦенностям.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	Для Каждого СтрокаНабор Из НаборЗаписей Цикл
		Если СтрокаНабор.Сделка = Сделка Тогда
			СтрокаНабор.Сделка = СделкаЗамена;
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПересчетДвижений");
	НаборЗаписей.Записать();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИсключаемыеТипыДокументовЗаменаСделки()
	ИсключаемыеТипыДокументов = Новый Массив;
	ИсключаемыеТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ИсключаемыеТипыДокументов.Добавить(Тип("ДокументСсылка.битРасчетАвансовПоАкцизам"));
	ИсключаемыеТипыДокументов.Добавить(Тип("ДокументСсылка.бг_РегистрацияБанковскихГарантий"));
	
	Возврат ИсключаемыеТипыДокументов;
КонецФункции

&НаСервереБезКонтекста
Процедура СформироватьДвиженияНаСервере(ТипОбъектов, Организация, НачалоПериода, КонецПериода)
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаДокументыФормированиеДвижений(ТипОбъектов);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Обработки.бг_АктуализацияДвиженийПоАкцизам.СформироватьДвиженияПоАкцизам(Выборка);
КонецПроцедуры

&НаСервере
Процедура СформироватьДвиженияПоДнямНаСервере(Организация, НачалоПериода, КонецПериода)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	Запрос.Текст = ТекстЗапросаФормированиеДвиженийПоДням();
	РезультатЗапроса = Запрос.Выполнить();
	
	Обработки.бг_АктуализацияДвиженийПоАкцизам.СформироватьДвиженияПоАкцизамПоДням(РезультатЗапроса);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаДокументыФормированиеДвижений(ТипОбъектов)
	ТекстЗапроса = "";
	
	ШаблонТекстЗапросаТипДокумента = "ВЫБРАТЬ
	|	Документ.Ссылка КАК Регистратор,
	|	Документ.Дата КАК ДатаДокумента,
	|	Документ.Проведен КАК Проведен,
	|	Представление(Документ.Ссылка) КАК РегистраторПредставление
	|ИЗ
	|	Документ.%1 КАК Документ
	|ГДЕ
	|	(&Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ИЛИ Документ.Организация = &Организация)
	|	И Документ.Дата >= &НачалоПериода
	|	И (Документ.Дата <= &КонецПериода
	|			ИЛИ &КонецПериода = ДАТАВРЕМЯ(1, 1, 1))";
	
	Для Каждого ТипОбъекта Из ТипОбъектов.Типы() Цикл
		МетаданныеДокумент = Метаданные.НайтиПоТипу(ТипОбъекта);
		
		Если Не ОбщегоНазначения.ЭтоДокумент(МетаданныеДокумент) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстЗапросаТипДокумента = СтрШаблон(ШаблонТекстЗапросаТипДокумента, МетаданныеДокумент.Имя);
		
		ТекстЗапроса = ТекстЗапроса
						+ ?(ПустаяСтрока(ТекстЗапроса), "", ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении(Истина))
						+ ТекстЗапросаТипДокумента;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента";
	
	Возврат ТекстЗапроса;
КонецФункции

&НаСервереБезКонтекста
Функция ТекстЗапросаФормированиеДвиженийПоДням()

	ДокументыСДвижениемСпирта = Новый Соответствие;
	ДокументыСДвижениемСпирта.Вставить("ТаможеннаяДекларацияИмпорт.Товары", "1");
	ДокументыСДвижениемСпирта.Вставить("ПоступлениеТоваровНаСклад.Товары", "2");
	ДокументыСДвижениемСпирта.Вставить("ДвижениеПродукцииИМатериалов.Товары", 
		"ВЫБОР 
		|		КОГДА Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаМатериаловВКладовую) 
		|			ТОГДА 3 
		|		ИНАЧЕ 5
		|	КОНЕЦ");
	ДокументыСДвижениемСпирта.Вставить("ПроизводствоБезЗаказа.МатериалыИРаботы", "3");
	ДокументыСДвижениемСпирта.Вставить("ЭтапПроизводства2_2.РасходМатериаловИРабот", "4");
	ДокументыСДвижениемСпирта.Вставить("ВнутреннееПотреблениеТоваров.Товары", "6");
	ДокументыСДвижениемСпирта.Вставить("ЗаявлениеОВвозеТоваров.Товары", "9");
	
	ДокументыСДвижениемГП= Новый Соответствие;
	ДокументыСДвижениемГП.Вставить("ВозвратТоваровОтКлиента.Товары", "1");
	ДокументыСДвижениемГП.Вставить("РеализацияТоваровУслуг.Товары", "7");
	ДокументыСДвижениемГП.Вставить("КорректировкаРеализации.Товары", "8");
	
	ТекстЗапроса = "";

	ШаблонТекстаДляСпирта = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка КАК Регистратор,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Ссылка) КАК РегистраторПредставление,
	|	НАЧАЛОПЕРИОДА(Документ.Ссылка.Дата, День) КАК Дата,
	|	%2 КАК Приоритет
	|ИЗ
	|	Документ.%1 КАК Документ
	|ГДЕ
	|	Документ.Ссылка.Проведен
	|	И &Организация В (Документ.Ссылка.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|	И Документ.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Документ.Ссылка.Организация.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям
	|	И Документ.Ссылка.Дата >= Документ.Ссылка.Организация.бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям
	|	И Документ.Номенклатура.ВидАлкогольнойПродукции.ВидЛицензии = ЗНАЧЕНИЕ(Перечисление.ВидыЛицензийАлкогольнойПродукции.Спирт)";
	
	ШаблонТекстаДляПродукции = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Документ.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Ссылка) КАК РегистраторПредставление,
	|	НАЧАЛОПЕРИОДА(Документ.Ссылка.Дата, День) КАК Дата,
	|	%2 КАК Приоритет
	|ИЗ
	|	Документ.%1 КАК Документ
	|ГДЕ
	|	Документ.Ссылка.Проведен
	|	И Документ.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И Документ.Ссылка.Организация = Документ.Серия.ПроизводительЕГАИС.Контрагент
	|	И Документ.Ссылка.Организация.бг_ВестиУчетАкцизовПоПриобретеннымЦенностям
	|	И Документ.Ссылка.Дата >= Документ.Ссылка.Организация.бг_ДатаНачалаУчетаАкцизовПоПриобретеннымЦенностям";

	Для каждого Элемент Из ДокументыСДвижениемСпирта Цикл
		ТекстЗапросаДокумент = СтрШаблон(ШаблонТекстаДляСпирта, Элемент.Ключ, Элемент.Значение);
		
		Если Элемент.Ключ = "ЭтапПроизводства2_2" Тогда
			ТекстЗапросаДокумент = СтрЗаменить(ТекстЗапросаДокумент, "Ссылка.Дата", "ДатаПроизводства");
		КонецЕсли;

		ТекстЗапроса = ТекстЗапроса
			+ ?(ПустаяСтрока(ТекстЗапроса), "", ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении(Истина))
			+ ТекстЗапросаДокумент;
	КонецЦикла;

	Для каждого Элемент Из ДокументыСДвижениемГП Цикл
		ТекстЗапросаДокумент = СтрШаблон(ШаблонТекстаДляПродукции, Элемент.Ключ, Элемент.Значение);

		ТекстЗапроса = ТекстЗапроса
			+ ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()
			+ ТекстЗапросаДокумент;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата, Приоритет 
	|ИТОГИ ПО
	|	Дата";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти
