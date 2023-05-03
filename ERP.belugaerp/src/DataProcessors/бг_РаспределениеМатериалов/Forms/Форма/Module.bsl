#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АдресМатериалыКРаспределению") Тогда
		ЗаполнитьМатериалыКРаспределению(Параметры.АдресМатериалыКРаспределению);
	КонецЕсли;
	
	Если Параметры.Свойство("Период") Тогда
		Период = Параметры.Период;
		ОтборПартииПроизводстваПериод.ДатаНачала = НачалоМесяца(Параметры.Период);
		ОтборПартииПроизводстваПериод.ДатаОкончания = КонецМесяца(Параметры.Период);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборПартииПроизводстваПериодПриИзменении(Элемент)
	ЗаполнитьБазуРаспределения();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПродукцияПриИзменении(Элемент)
	ЗаполнитьБазуРаспределения();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрОтметкаМатериалыПриИзменении(Элемент)
	СтруктураОтбора = Новый Структура();
	
	Если ФильтрОтметкаМатериалы Тогда
		СтруктураОтбора.Вставить("ТребуетсяРаспределить", Истина);
	КонецЕсли;
	
	Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	Если Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг1 Тогда
		Если ПроверитьЗаполнениеСтатьиКалькуляции()
			И РассчитатьОрганизациюМатериалыКРаспределению() Тогда
			ЗаполнитьБазуРаспределения();
			
			Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг2;
			Элементы.СтраницыКомандыНиз.ТекущаяСтраница = Элементы.СтраницаКомандыНизШаг2;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг2 Тогда
		Если ВыбранаБазаРаспределения() Тогда
			СформироватьДокументыРаспределения();
			
			Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг3;
			Элементы.СтраницыКомандыНиз.ТекущаяСтраница = Элементы.СтраницаКомандыНизШаг3;
		Иначе
			ТекстСообщение = НСтр("ru = 'Не выбрана база распределения'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщение);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьЗаголовокФормы(Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Если Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг2 Тогда
		Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница = Элементы.СтраницаШаг1;
		Элементы.СтраницыКомандыНиз.ТекущаяСтраница = Элементы.СтраницаКомандыНизШаг1;
	КонецЕсли;
	
	УстановитьЗаголовокФормы(Элементы.СтраницыОсновнаяПанель.ТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеМатериалы(Команда)
	УстановитьОтметкуВыборМатериалов(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СброситьВыборМатериалов(Команда)
	УстановитьОтметкуВыборМатериалов(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеСтрокиБазыРаспределения(Команда)
	УстановитьОтметкуВыборБазыРаспределения(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СброситьВыборСтрокБазыРаспределения(Команда)
	УстановитьОтметкуВыборБазыРаспределения(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьиКалькуляции(Команда)
	СтатьяКалькуляции = Неопределено;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьСтатьиКалькуляцииВТабличнойЧастиЗавершение",
		ЭтотОбъект, Новый Структура("ВыделенныеСтроки, ТабЧасть", Элементы.Материалы.ВыделенныеСтроки, Материалы));
	
	ОткрытьФорму("Справочник.СтатьиКалькуляции.ФормаВыбора", , ЭтотОбъект, , , ,
						Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСформированныеДокументы(Команда)
	ВыделенныеСтроки = Элементы.ДокументыРаспределения.ВыделенныеСтроки;
	ПометитьНаУдалениеСформированныеДокументыНаСервере(ВыделенныеСтроки);
	
	Элементы.ДокументыРаспределения.Обновить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыСтатьяКалькуляции.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.ТребуетсяРаспределить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Материалы.СтатьяКалькуляции");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗаголовокФормы(Страница)
	
	Если Страница = Элементы.СтраницаШаг1 Тогда
		
		Элементы.ПодЗаголовок.Заголовок = НСтр("ru = 'Шаг 1 из 3. Отбор материалов'");
		
	ИначеЕсли Страница = Элементы.СтраницаШаг2 Тогда
		
		Элементы.ПодЗаголовок.Заголовок = НСтр("ru = 'Шаг 2 из 3. Выбор базы распределения'");
		
	ИначеЕсли Страница = Элементы.СтраницаШаг3 Тогда
		
		Элементы.ПодЗаголовок.Заголовок = НСтр("ru = 'Шаг 3 из 3. Уточнение сформированных документов распределения'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыКРаспределению(АдресМатериалыКРаспределению)
	МатериалыКРаспределению = ПолучитьИзВременногоХранилища(АдресМатериалыКРаспределению);
	Для Каждого СтрокаМатериал Из МатериалыКРаспределению Цикл
		Если СтрокаМатериал.Наличие = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаМатериал = Материалы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаМатериал, СтрокаМатериал);
		НоваяСтрокаМатериал.Распределить = СтрокаМатериал.Наличие;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкуВыборМатериалов(Значение)
	ВыделенныеСтроки = Элементы.Материалы.ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТаблицы = Материалы.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		СтрокаТаблицы.ТребуетсяРаспределить = Значение;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкуВыборБазыРаспределения(Значение)
	ВыделенныеСтроки = Элементы.ПартииПроизводства.ВыделенныеСтроки;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		СтрокаТаблицы = ПартииПроизводства.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		СтрокаТаблицы.ТребуетсяРаспределить = Значение;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеСтатьиКалькуляции()
	Отбор = Новый Структура("ТребуетсяРаспределить, СтатьяКалькуляции", Истина, Справочники.СтатьиКалькуляции.ПустаяСсылка());
	
	МатериалыУказатьСтатьюКалькуляции = Материалы.Выгрузить(Отбор, "Номенклатура, СтатьяКалькуляции");
	Для Каждого СтрокаМатериал Из МатериалыУказатьСтатьюКалькуляции Цикл
		ТекстСообщения = НСтр("ru = 'Для материала ""%1"" требуется указать статью калькуляции'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаМатериал.Номенклатура);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЦикла;
	
	Возврат МатериалыУказатьСтатьюКалькуляции.Количество() = 0;
КонецФункции

&НаСервере
Функция РассчитатьОрганизациюМатериалыКРаспределению()
	Отбор = Новый Структура("ТребуетсяРаспределить", Истина);
	
	РаспределяемыеМатериалы = Материалы.Выгрузить(Отбор, "Организация");
	РаспределяемыеМатериалы.Свернуть("Организация");
	
	Если РаспределяемыеМатериалы.Количество() = 0 Тогда
		ТекстСообщение = НСтр("ru = 'Не выбраны материалы к распределению'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщение);
		Возврат Ложь;
	ИначеЕсли РаспределяемыеМатериалы.Количество() > 1 Тогда
		ТекстСообщение = НСтр("ru = 'Необходимо выбрать материалы к распределению по одной организации'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщение);
		Возврат Ложь;
	КонецЕсли;
	
	Организация = РаспределяемыеМатериалы[0].Организация;
	
	Возврат Истина;
КонецФункции

&НаСервере
Функция ВыбранаБазаРаспределения()
	Отбор = Новый Структура("ТребуетсяРаспределить", Истина);
	
	Возврат ПартииПроизводства.НайтиСтроки(Отбор).Количество() > 0;
КонецФункции

&НаСервере
Процедура ЗаполнитьБазуРаспределения()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыпускПродукцииОбороты.Распоряжение КАК Распоряжение,
	|	ВЫРАЗИТЬ(ВыпускПродукцииОбороты.Распоряжение КАК Документ.ЭтапПроизводства2_2).Спецификация КАК Спецификация,
	|	ВЫРАЗИТЬ(ВыпускПродукцииОбороты.Распоряжение КАК Документ.ЭтапПроизводства2_2).ПартияПроизводства КАК ПартияПроизводства,
	|	ВЫРАЗИТЬ(ВыпускПродукцииОбороты.Распоряжение КАК Документ.ЭтапПроизводства2_2).Подразделение КАК Подразделение,
	|	ВыпускПродукцииОбороты.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВыпускПродукцииОбороты.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ВыпускПродукцииОбороты.КоличествоОборот КАК Коэффициент,
	|	ИСТИНА КАК ТребуетсяРаспределить
	|ИЗ
	|	РегистрНакопления.ВыпускПродукции.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И (НЕ &ОтборПоПродукции
	|					ИЛИ АналитикаУчетаНоменклатуры.Номенклатура В (&Продукция))) КАК ВыпускПродукцииОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВыпускПродукцииОбороты.АналитикаУчетаНоменклатуры.Номенклатура.Наименование";
	Запрос.УстановитьПараметр("НачалоПериода", ОтборПартииПроизводстваПериод.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ОтборПартииПроизводстваПериод.ДатаОкончания));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОтборПоПродукции", ОтборПродукция.Количество() > 0);
	Запрос.УстановитьПараметр("Продукция", ОтборПродукция.ВыгрузитьЗначения());
	
	Результат = Запрос.Выполнить();
	ПартииПроизводства.Загрузить(Результат.Выгрузить());
КонецПроцедуры

&НаСервере
Процедура СформироватьДокументыРаспределения()
	СформированныеДокументы = Новый Массив;
	
	ОтборБазаРаспределения = Новый Структура("ТребуетсяРаспределить", Истина);
	БазаРаспределения = ПартииПроизводства.Выгрузить(ОтборБазаРаспределения);
	
	Для Каждого СтрокаМатериал Из Материалы Цикл
		Если Не СтрокаМатериал.ТребуетсяРаспределить Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеЗаполнения = СтруктураДанныеЗаполнения(Период);
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, СтрокаМатериал);
		
		НовыйДокументРаспределения = Документы.РаспределениеПроизводственныхЗатрат.СоздатьДокумент();
		НовыйДокументРаспределения.Заполнить(ДанныеЗаполнения);
		НовыйДокументРаспределения.Количество   = СтрокаМатериал.Распределить;
		НовыйДокументРаспределения.Распределить = 0;
		
		бг_РаспределениеПроизводственныхЗатрат.бг_РаспределитьМатериалыПоПартиямПроизводства(
														НовыйДокументРаспределения,
														НовыйДокументРаспределения.Количество,
														БазаРаспределения,
														СтрокаМатериал.СтатьяКалькуляции);
		
		Попытка
			НовыйДокументРаспределения.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
			
			НовыйДокументРаспределения.Записать();
		КонецПопытки;
		
		СформированныеДокументы.Добавить(НовыйДокументРаспределения.Ссылка);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДокументыРаспределения, "Ссылка", СформированныеДокументы,
											ВидСравненияКомпоновкиДанных.ВСписке);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураДанныеЗаполнения(Период)
	
	СтруктураДокумента = Новый Структура("НовоеПроизводство, Дата, Организация, Подразделение, АналитикаУчетаНоменклатуры,
	|Склад, Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Назначение, Ссылка, Распределить");
	
	СтруктураДокумента.НовоеПроизводство = Истина;
	СтруктураДокумента.Дата = КонецМесяца(Период);
	
	Возврат СтруктураДокумента;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСтатьиКалькуляцииВТабличнойЧастиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	ТабЧасть = ДополнительныеПараметры.ТабЧасть;
	СтатьяКалькуляции = Результат;
	
	Если Не ЗначениеЗаполнено(СтатьяКалькуляции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		СтрокаТаблицы = ТабЧасть.НайтиПоИдентификатору(Строка);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.СтатьяКалькуляции = СтатьяКалькуляции;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПометитьНаУдалениеСформированныеДокументыНаСервере(СписокДокументы)
	Попытка
		ОбщегоНазначенияУТ.УстановитьПометкуУдаленияДокументов(СписокДокументы);
	Исключение
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
