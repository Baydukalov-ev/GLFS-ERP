#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справочники.бг_ДополнительныеКонстанты.АктуализироватьКонстанты();
	СоздатьРеквизитыТаблицФормы();
	ИнициализироватьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьНастройки(Команда)
	ИнициализироватьИнтерфейс();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонстантаПриИзменении(Элемент)
	
	ИдентификаторКонстанты = СтрЗаменить(Элемент.Имя, "ПолеКонстанта", "");
	УстановитьЗначениеКонстантыБезРазреза(ИдентификаторКонстанты);
	
КонецПроцедуры

&НаКлиенте
Процедура КонстантаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИдентификаторКонстанты = СтрЗаменить(Элемент.Имя, "ПолеКонстанта", "");
	ДанныеКонстантыСтрока = ДанныеКонстантыПоИдентификатору(ДанныеКонстант, ИдентификаторКонстанты);
	
	Если ЗначениеЗаполнено(ДанныеКонстантыСтрока.ИмяФормы) Тогда
		
		ОткрытьФорму(ДанныеКонстантыСтрока.ИмяФормы);
		
	Иначе
		
		ДанныеКонстанты = Новый Структура(
			"Константа, Идентификатор, Наименование, ОбязательноеЗаполнение, ТипЗначения, ТипРазреза, ИмяФормы");
		
		ЗаполнитьЗначенияСвойств(ДанныеКонстанты, ДанныеКонстантыСтрока);
		
		ДополнительныеПараметры = Новый Структура("ДанныеКонстанты", ДанныеКонстанты);
		
		ОповещениеПоЗавершении = Новый ОписаниеОповещения(
			"КонстантаНажатиеВводЗначенийПоРазрезуЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ДанныеКонстанты", ДанныеКонстанты);
		
		ОткрытьФорму(
			"РегистрСведений.бг_ЗначенияДополнительныхКонстант.Форма.ФормаВводаЗначенийПоРазрезу",
			ПараметрыОткрытия,
			ЭтотОбъект,
			, // Уникальность
			, // Окно
			, // НавигационнаяСсылка
			ОповещениеПоЗавершении,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИнтерфейса

&НаСервере
Процедура ИнициализироватьИнтерфейс()

	// Удалить реквизиты и элементы формы
	ОчиститьПерезаполняемыеРеквизитыЭлементыФормы();
	ОчиститьСлужебныеТаблицы();
	
	// Подготовить служебные таблицы с данными констант и разделов.
	ЗаполнитьТаблицыКонстант();
	ЗаполнитьТаблицуГруппКонстант();
	
	// Инициализировать интерфейс формы.
	СоздатьЭлементыФормыГруппКонстант();
	СоздатьРеквизитыФормыКонстантыСервер();
	ЗаполнитьРеквизитыФормыКонстантыСервер();
	СоздатьЭлементыФормыКонстант();

КонецПроцедуры

&НаСервере
Процедура ОчиститьПерезаполняемыеРеквизитыЭлементыФормы()

	// Удалить элементы формы.
	ИменаГруппРазделовКонстант = Новый Массив;
	Для каждого ГруппаРазделовКонстант Из Элементы.СтраницыРазделовКонстантПерезаполняемая.ПодчиненныеЭлементы Цикл
		ИменаГруппРазделовКонстант.Добавить(ГруппаРазделовКонстант.Имя);
	КонецЦикла;
	
	Для каждого ИмяГруппыРазделовКонстант Из ИменаГруппРазделовКонстант Цикл
		Элементы.Удалить(Элементы[ИмяГруппыРазделовКонстант]);
	КонецЦикла;
	
	// Удалить реквизиты формы.
	УдаляемыеРеквизиты = Новый Массив;
	Для каждого СтрокаДанныеКонстант Из ДанныеКонстант Цикл
		УдаляемыеРеквизиты.Добавить(СтрокаДанныеКонстант.Идентификатор);
	КонецЦикла;
	
	Если УдаляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСлужебныеТаблицы()

	ДанныеКонстант.Очистить();
	ЗначенияКонстант.Очистить();
	ГруппыКонстант.Очистить();

КонецПроцедуры

&НаСервере
Процедура СоздатьРеквизитыТаблицФормы()

	ДобавляемыеРеквизиты = Новый Массив;
	
	ТипЗначения = Метаданные.РегистрыСведений.бг_ЗначенияДополнительныхКонстант.Ресурсы.Значение.Тип;
	ТипРазреза = Метаданные.РегистрыСведений.бг_ЗначенияДополнительныхКонстант.Измерения.Разрез.Тип;
	
	// Реквизиты таблицы ДанныеКонстант
	ДобавляемыеРеквизиты.Добавить(
		Новый РеквизитФормы(
			"ЗначениеПоУмолчанию",
		    ТипЗначения,
			"ДанныеКонстант"));
		
	// Реквизиты таблицы ЗначенияКонстант
	ДобавляемыеРеквизиты.Добавить(
		Новый РеквизитФормы(
			"Разрез",
		    ТипРазреза,
			"ЗначенияКонстант"));
			
	ДобавляемыеРеквизиты.Добавить(
		Новый РеквизитФормы(
			"Значение",
		    ТипЗначения,
			"ЗначенияКонстант"));
		
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицыКонстант()

	ТаблицаЗначенийКонстантБД = РегистрыСведений.бг_ЗначенияДополнительныхКонстант.ЗначенияВсехКонстант();
	ТаблицаОписанияКонстант = бг_КонстантыПовтИсп.ТаблицаОписанияКонстант();
	ТаблицаКонстантБД = Справочники.бг_ДополнительныеКонстанты.ТаблицаКонстантБД(Истина);
	
	Для каждого СтрокаОписанияКонстант Из ТаблицаОписанияКонстант Цикл
		
		ПараметрыПоиска = Новый Структура("Идентификатор", СтрокаОписанияКонстант.Идентификатор);
		ЗначенияПоИдентификатору = ТаблицаЗначенийКонстантБД.НайтиСтроки(ПараметрыПоиска);
		
		Если ЗначенияПоИдентификатору.Количество() = 0 Тогда
			
			// У константы пока нет значений в регистре.
			НоваяСтрокаДанныеКонстант = ДанныеКонстант.Добавить();
			
			СтрокиКонстантБД = ТаблицаКонстантБД.НайтиСтроки(ПараметрыПоиска);
			
			Если СтрокиКонстантБД.Количество() = 0 Тогда
				
				// Этого не должно произойти никогда, т.к. константы актуализируются при старте обработки,
				// при этом недостающие константы создаются.
				ВызватьИсключение СтрШаблон(
					НСтр("ru='Не найдена константа по идентификатору %1'"),
					СтрокаОписанияКонстант.Идентификатор);
					
			ИначеЕсли СтрокиКонстантБД.Количество() > 1 Тогда
					
				// Этого не должно произойти никогда, т.к. константы актуализируются при старте обработки,
				// при этом лишние константы помечаются на удаление, у них очищается идентификатор.
				ВызватьИсключение СтрШаблон(
					НСтр("ru='Найдено несколько констант по идентификатору %1'"),
					СтрокаОписанияКонстант.Идентификатор);
					
			Иначе
				НоваяСтрокаДанныеКонстант.Константа = СтрокиКонстантБД[0].Константа;
			КонецЕсли;
				
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДанныеКонстант, СтрокаОписанияКонстант);
			
			Если СтрокаОписанияКонстант.ЗначениеПоУмолчанию <> Неопределено Тогда
				
				Если Не СтрокаОписанияКонстант.ХранитьСтроковыйГУИД
					И Не СтрокаОписанияКонстант.ТипЗначения.СодержитТип(ТипЗнч(СтрокаОписанияКонстант.ЗначениеПоУмолчанию)) Тогда
					
					ВызватьИсключение СтрШаблон(
						НСтр("ru='Некорректный тип значения по умолчанию константы %1'"),
						СтрокаОписанияКонстант.Идентификатор);
						
				КонецЕсли;
				
				НоваяСтрокаЗначенияКонстант = ЗначенияКонстант.Добавить();
				НоваяСтрокаЗначенияКонстант.Идентификатор = СтрокаОписанияКонстант.Идентификатор;
				НоваяСтрокаЗначенияКонстант.Значение = СтрокаОписанияКонстант.ЗначениеПоУмолчанию;
			КонецЕсли;
				
		Иначе
			
			НоваяСтрокаДанныеКонстант = ДанныеКонстант.Добавить();
			НоваяСтрокаДанныеКонстант.Константа = ЗначенияПоИдентификатору[0].Константа;
				
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДанныеКонстант, СтрокаОписанияКонстант);
			
			Для каждого СтрокаЗначениеПоИдентификатору Из ЗначенияПоИдентификатору Цикл
				
				Если СтрокаЗначениеПоИдентификатору.Константа <> ЗначенияПоИдентификатору[0].Константа Тогда
					// Этого не должно произойти никогда, т.к. константы актуализируются при старте обработки,
					// при этом дубли значений констант по идентификатору очищаются, если такая ситуация была создана.
					ВызватьИсключение СтрШаблон(
						НСтр("ru='Обнаружено несколько констант по идентификатору %1'"),
						СтрокаОписанияКонстант.Идентификатор);
				КонецЕсли;
				
				НоваяСтрокаЗначенияКонстант = ЗначенияКонстант.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаЗначенияКонстант, СтрокаЗначениеПоИдентификатору);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуГруппКонстант()
	
	ТаблицаГруппыКонстант = ДанныеКонстант.Выгрузить(, "Раздел, Подраздел");
	ТаблицаГруппыКонстант.Свернуть("Раздел, Подраздел");
	ГруппыКонстант.Загрузить(ТаблицаГруппыКонстант);

	ПредставленияГруппКонстант = Справочники.бг_ДополнительныеКонстанты.ПредставленияГруппКонстант();
	
	Для каждого СтрокаГруппыКонстант Из ГруппыКонстант Цикл
		ОбработатьГруппуКонстант(СтрокаГруппыКонстант, "Раздел", ПредставленияГруппКонстант);	
		ОбработатьГруппуКонстант(СтрокаГруппыКонстант, "Подраздел", ПредставленияГруппКонстант);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбработатьГруппуКонстант(СтрокаГруппыКонстант, ИмяПоля, ПредставленияГруппКонстант)
	
	Если ПустаяСтрока(СтрокаГруппыКонстант[ИмяПоля]) Тогда
		
		ДанныеПустойГруппыКонстант = ДанныеПустойГруппыКонстант(ИмяПоля);
		
		// Группы константы не указана.
		СтрокаГруппыКонстант[ИмяПоля] = ДанныеПустойГруппыКонстант.Имя;
		СтрокаГруппыКонстант[ИмяПоля + "Представление"] = ДанныеПустойГруппыКонстант.Представление;
		
	Иначе
		
		// Группы константы указана, необходимо получить ее представление.
		ПредставленияГруппКонстант.Свойство(СтрокаГруппыКонстант[ИмяПоля], СтрокаГруппыКонстант[ИмяПоля + "Представление"]);
		
		Если ПустаяСтрока(СтрокаГруппыКонстант[ИмяПоля + "Представление"]) Тогда
			
			// Для группы констант не указано особое представление, использовать имя в качестве представления.
			СтрокаГруппыКонстант[ИмяПоля + "Представление"] = СтрокаГруппыКонстант[ИмяПоля];
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПустойГруппыКонстант(ИмяПоля)

	ДанныеПустойГруппыКонстант = Новый Структура;
	
	ДанныеПустойГруппыКонстант.Вставить("Имя", ИмяПоля + "ПоУмолчанию");
	ДанныеПустойГруппыКонстант.Вставить("Представление", ЗаголовокПустойГруппы());
	
	Возврат ДанныеПустойГруппыКонстант;

КонецФункции

&НаСервереБезКонтекста
Функция ЗаголовокПустойГруппы()
	Возврат "<без раздела>";
КонецФункции

&НаСервере
Процедура СоздатьЭлементыФормыГруппКонстант()
	
	Разделы = ГруппыКонстант.Выгрузить(, "Раздел, РазделПредставление");
	Разделы.Свернуть("Раздел, РазделПредставление");

	Для каждого СтрокаРазделы Из Разделы Цикл
		
		// Группа раздела
		ГруппаФормыРаздел = Элементы.Добавить(
			СтрШаблон("ГруппаРаздел%1", СтрокаРазделы.Раздел),
			Тип("ГруппаФормы"),
			Элементы.СтраницыРазделовКонстантПерезаполняемая);
			
		ГруппаФормыРаздел.Вид = ВидГруппыФормы.Страница;
		ГруппаФормыРаздел.Заголовок = СтрокаРазделы.РазделПредставление;
		ГруппаФормыРаздел.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаФормыРаздел.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Двойной;
		ГруппаФормыРаздел.РастягиватьПоГоризонтали = Истина;
		ГруппаФормыРаздел.РастягиватьПоВертикали = Истина;
		
		// Группы подразделов
		ГруппаФормыПодразделСтраницы = Элементы.Добавить(
			СтрШаблон("ГруппаРаздел%1_Страницы", СтрокаРазделы.Раздел),
			Тип("ГруппаФормы"),
			ГруппаФормыРаздел);
		ГруппаФормыПодразделСтраницы.Вид = ВидГруппыФормы.Страницы;
		ГруппаФормыПодразделСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСлеваГоризонтально;
		ГруппаФормыПодразделСтраницы.РастягиватьПоГоризонтали = Истина;
		ГруппаФормыПодразделСтраницы.РастягиватьПоВертикали = Истина;
		
		ПараметрыПоискаПодразделов = Новый Структура("Раздел", СтрокаРазделы.Раздел);
		СтрокиПодразделы = ГруппыКонстант.НайтиСтроки(ПараметрыПоискаПодразделов);
		
		Для каждого СтрокаПодразделы Из СтрокиПодразделы Цикл
		
			ГруппаФормыПодраздел = Элементы.Добавить(
				ИмяГруппыФормыПодразделаКонстант(СтрокаРазделы.Раздел, СтрокаПодразделы.Подраздел),
				Тип("ГруппаФормы"),
				ГруппаФормыПодразделСтраницы);
				
			ГруппаФормыПодраздел.Вид = ВидГруппыФормы.Страница;
			ГруппаФормыПодраздел.Заголовок = СтрокаПодразделы.ПодразделПредставление;
			ГруппаФормыПодраздел.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
			ГруппаФормыПодраздел.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаФормыПодраздел.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Двойной;
			ГруппаФормыПодраздел.РастягиватьПоГоризонтали = Истина;
			ГруппаФормыПодраздел.РастягиватьПоВертикали = Истина;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяГруппыФормыПодразделаКонстант(Знач Раздел, Знач Подраздел)

	ИмяГруппыФормыПодразделаКонстант = "";
	
	Если ПустаяСтрока(Раздел) Тогда
		ДанныеПустойГруппыКонстант = ДанныеПустойГруппыКонстант("Раздел");
		Раздел = ДанныеПустойГруппыКонстант.Имя;
	КонецЕсли;
	
	Если ПустаяСтрока(Подраздел) Тогда
		ДанныеПустойГруппыКонстант = ДанныеПустойГруппыКонстант("Подраздел");
		Подраздел = ДанныеПустойГруппыКонстант.Имя;
	КонецЕсли;
	
	Возврат СтрШаблон("ГруппаПодраздел%1%2", Раздел, Подраздел);

КонецФункции

&НаСервере
Процедура СоздатьРеквизитыФормыКонстантыСервер()

	ДобавляемыеРеквизиты = Новый Массив;
	
	Для каждого ДанныеКонстанты Из ДанныеКонстант Цикл
		
		Если ЗначениеЗаполнено(ДанныеКонстанты.ИмяФормы) Тогда
			
			// Константа редактируется в особой форме.
			ДобавляемыеРеквизиты.Добавить(
				Новый РеквизитФормы(
					ДанныеКонстанты.Идентификатор,
					ДанныеКонстанты.ТипЗначения,
					, // Путь
					ДанныеКонстанты.Наименование));
			
		ИначеЕсли ЭтоКонстантаБезРазреза(ДанныеКонстанты) Тогда
			
			// Обычная константа, редактируется в поле ввода, не имеет разрезов.
			ДобавляемыеРеквизиты.Добавить(
				Новый РеквизитФормы(
					ДанныеКонстанты.Идентификатор,
					ДанныеКонстанты.ТипЗначения,
					, // Путь
					ДанныеКонстанты.Наименование));
					
		Иначе
			
			// Имеет список значений.
			ДобавляемыеРеквизиты.Добавить(
				Новый РеквизитФормы(
					ДанныеКонстанты.Идентификатор,
					ОбщегоНазначения.ОписаниеТипаСтрока(100),
					, // Путь
					ЗаголовокКонстантыСРазрезом(ДанныеКонстант, ДанныеКонстанты.Идентификатор, ДанныеКонстанты)));
			
		КонецЕсли;
	КонецЦикла;
			
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыКонстантыСервер()
	
	// Вывести значения констант без резреза - в одноименные реквизиты формы.
	ПараметрыПоиска = Новый Структура("Разрез", Неопределено);
	ЗначенияКонстантБезРазреза = ЗначенияКонстант.НайтиСтроки(ПараметрыПоиска);
	
	Для каждого ДанныеЗначенияКонстанты Из ЗначенияКонстантБезРазреза Цикл
		
		ДанныеКонстанты = ДанныеКонстантыПоИдентификатору(ДанныеКонстант, ДанныеЗначенияКонстанты.Идентификатор);
		
		Если ДанныеКонстанты.ХранитьСтроковыйГУИД Тогда
			
			Если Не ЗначениеЗаполнено(ДанныеЗначенияКонстанты.Значение) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДанныеКонстанты.ИмяТипа) Тогда
				ВызватьИсключение НСтр("ru='Для констант, хранимых по ГУИДу, необходимо задать имя типа.'");
			КонецЕсли;
			
			Если СтрНайти(ДанныеКонстанты.ИмяТипа, "Справочник") = 0 Тогда
				ВызватьИсключение НСтр("ru='Предусмотрено хранение значение констант по ГУИДу только для справочников.'");
			КонецЕсли;
			
			ИмяОбъектаМетаданных = СтрЗаменить(ДанныеКонстанты.ИмяТипа, "СправочникСсылка.", "");
			
			ЭтотОбъект[ДанныеЗначенияКонстанты.Идентификатор] = Справочники[ИмяОбъектаМетаданных].ПолучитьСсылку(
				Новый УникальныйИдентификатор(ДанныеЗначенияКонстанты.Значение));
			
		Иначе
			ЭтотОбъект[ДанныеЗначенияКонстанты.Идентификатор] = ДанныеЗначенияКонстанты.Значение;
		КонецЕсли;
	КонецЦикла;
	
	// Вывести значения констант с резрезом - надписи с указанием подобранных значений.
	Для каждого ДанныеКонстанты Из ДанныеКонстант Цикл
		
		Если ЭтоКонстантаБезРазреза(ДанныеКонстанты) Или ЗначениеЗаполнено(ДанныеКонстанты.ИмяФормы) Тогда
			Продолжить;
		КонецЕсли;
			
		ЭтотОбъект[ДанныеКонстанты.Идентификатор] = ПредставлениеКонстантыСРазрезом(
			ДанныеКонстант,
			ЗначенияКонстант,
			ДанныеКонстанты.Идентификатор,
			ДанныеКонстанты);
			
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыФормыКонстант()

	Для каждого ДанныеКонстанты Из ДанныеКонстант Цикл
		
		// Группа константы
		ГруппаФормыКонстанта = Элементы.Добавить(
			СтрШаблон("ГруппаКонстанта%1", ДанныеКонстанты.Идентификатор),
			Тип("ГруппаФормы"),
			Элементы[ИмяГруппыФормыПодразделаКонстант(
				ДанныеКонстанты.Раздел,
				ДанныеКонстанты.Подраздел)]);
				
		ГруппаФормыКонстанта.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаФормыКонстанта.ОтображатьЗаголовок = Ложь;
		ГруппаФормыКонстанта.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		ГруппаФормыКонстанта.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение;
				
		// Элемент константы
		ЭлементФормыКонстанта = Элементы.Добавить(
			СтрШаблон("ПолеКонстанта%1", ДанныеКонстанты.Идентификатор),
			Тип("ПолеФормы"),
			ГруппаФормыКонстанта);
			
		ЭлементФормыКонстанта.ПутьКДанным = ДанныеКонстанты.Идентификатор;
			
		ЭлементФормыКонстанта.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
		Если ЭтоКонстантаБезРазреза(ДанныеКонстанты) Тогда	
			
			// Обычная константа, редактируется в поле ввода, не имеет разрезов.
			Если ДанныеКонстанты.ТипЗначения = Новый ОписаниеТипов("Булево") Тогда
				ЭлементФормыКонстанта.Вид = ВидПоляФормы.ПолеФлажка;
				ЭлементФормыКонстанта.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			Иначе
				ЭлементФормыКонстанта.Вид = ВидПоляФормы.ПолеВвода;
				ЭлементФормыКонстанта.АвтоОтметкаНезаполненного = ДанныеКонстанты.ОбязательноеЗаполнение;	
				Если ДанныеКонстанты.ТипЗначения <> Новый ОписаниеТипов("Строка") Тогда
					ЭлементФормыКонстанта.КнопкаВыбора = Истина;
					ЭлементФормыКонстанта.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
				КонецЕсли;
			КонецЕсли;
			
			Если Строка(ДанныеКонстанты.ТипЗначения) = "Число" Тогда
				ЭлементФормыКонстанта.ФорматРедактирования = "ЧГ=0";
			КонецЕсли;
			
			ЭлементФормыКонстанта.УстановитьДействие("ПриИзменении", "КонстантаПриИзменении");	
			
		Иначе
			
			// Имеет список значений или редактируется в особой форме.
			ЭлементФормыКонстанта.Вид = ВидПоляФормы.ПолеНадписи;
			ЭлементФормыКонстанта.Гиперссылка = Истина;
			ЭлементФормыКонстанта.Высота = 4;
			ЭлементФормыКонстанта.РастягиватьПоВертикали = Ложь;
			
			ЭлементФормыКонстанта.УстановитьДействие("Нажатие", "КонстантаНажатие");	
			
		КонецЕсли;	
			
		Если Не ПустаяСтрока(ДанныеКонстанты.Описание) Тогда
			ЭлементФормыКонстанта.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			ЭлементФормыКонстанта.РасширеннаяПодсказка.Заголовок = ДанныеКонстанты.Описание;
		Иначе
			ЭлементФормыКонстанта.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти // Конец ИнициализацияИнтерфейса

&НаСервере
Процедура УстановитьЗначениеКонстантыБезРазреза(Идентификатор)
	
	ДанныеКонстанты = ДанныеКонстантыПоИдентификатору(ДанныеКонстант, Идентификатор);
	
	Если ДанныеКонстанты.ХранитьСтроковыйГУИД Тогда
		ЗначениеКонстанты = Строка(ЭтотОбъект[Идентификатор].УникальныйИдентификатор());
	Иначе
		ЗначениеКонстанты = ЭтотОбъект[Идентификатор];
	КонецЕсли;
	
	РегистрыСведений.бг_ЗначенияДополнительныхКонстант.УстановитьЗначениеКонстантыБезРазреза(
		ДанныеКонстанты.Константа,
		ЗначениеКонстанты);
		
	СтрокиЗначенияКонстант = ЗначенияКонстант.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
	Если СтрокиЗначенияКонстант.Количество() = 0 Тогда
		СтрокаЗначенияКонстант = ЗначенияКонстант.Добавить();
		СтрокаЗначенияКонстант.Идентификатор = Идентификатор;
	Иначе
		СтрокаЗначенияКонстант = СтрокиЗначенияКонстант[0];	
	КонецЕсли;
	
	СтрокаЗначенияКонстант.Значение = ЗначениеКонстанты;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанныеКонстантыПоИдентификатору(ДанныеКонстант, Идентификатор)
	
	Возврат ДанныеКонстант.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор))[0];
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначенияКонстантыСРазрезом(ЗначенияКонстант, ДанныеКонстанты, Идентификатор)

	ПараметрыПоиска = Новый Структура("Идентификатор", Идентификатор);
	СтрокиЗначенияКонстанты = ЗначенияКонстант.НайтиСтроки(ПараметрыПоиска);
	
	ЗначенияКонстанты = Новый Соответствие;
	
	Для каждого СтрокаЗначенияКонстанты Из СтрокиЗначенияКонстанты Цикл
		ЗначенияКонстанты.Вставить(
			?(СтрокаЗначенияКонстанты.Разрез = Неопределено,
				ПустоеЗначениеТипаРазреза(ДанныеКонстанты.ТипРазреза),
				СтрокаЗначенияКонстанты.Разрез),
			СтрокаЗначенияКонстанты.Значение);
	КонецЦикла;
	
	Возврат ЗначенияКонстанты;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокКонстантыСРазрезом(ДанныеКонстант, Идентификатор, ДанныеКонстанты = Неопределено)
	
	Если ДанныеКонстанты = Неопределено Тогда
		ДанныеКонстанты = ДанныеКонстантыПоИдентификатору(ДанныеКонстант, Идентификатор);
	КонецЕсли;
	
	ЗаголовокКонстанты = СтрШаблон(
		НСтр("ru='%1 (в разрезе %2)'"),
		ДанныеКонстанты.Наименование,
		ПредставлениеТипаРазреза(ДанныеКонстанты.ТипРазреза));

	Возврат ЗаголовокКонстанты;	
		
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеКонстантыСРазрезом(ДанныеКонстант, ЗначенияКонстант, Идентификатор, ДанныеКонстанты = Неопределено)
	
	Если ДанныеКонстанты = Неопределено Тогда
		ДанныеКонстанты = ДанныеКонстантыПоИдентификатору(ДанныеКонстант, Идентификатор);
	КонецЕсли;
	
	ЗначенияКонстанты = ЗначенияКонстантыСРазрезом(ЗначенияКонстант, ДанныеКонстанты, Идентификатор);	
	
	КоличествоЗначений = ЗначенияКонстанты.Количество();
	
	Если КоличествоЗначений = 0 Тогда
		
		ПредставлениеКонстанты = "<значения не выбраны>";
		
	Иначе
		
		ПредставлениеКонстанты = "";
		
		СчетчикВыведеноЗначений = 0;
		
		ПредставлениеПустойРазрез = НСтр("ru='<пустой разрез>';en='<empty analytics>'");
		
		Для каждого ЭлементЗначенияКонстанты Из ЗначенияКонстанты Цикл
						
			ПредставлениеКонстанты = ПредставлениеКонстанты
				+ ?(ПустаяСтрока(ПредставлениеКонстанты), "", Символы.ПС)
				+ СтрШаблон("%1 = %2",
					?(ЗначениеЗаполнено(ЭлементЗначенияКонстанты.Ключ), ЭлементЗначенияКонстанты.Ключ, ПредставлениеПустойРазрез),
					ЭлементЗначенияКонстанты.Значение);
					
			СчетчикВыведеноЗначений = СчетчикВыведеноЗначений + 1;		
					
			Если СчетчикВыведеноЗначений = 3 И КоличествоЗначений > 3 Тогда
				
				ОсталосьВывестиЗначений = КоличествоЗначений - СчетчикВыведеноЗначений;
				
				ПредставлениеЭлемента = СтрШаблон(
					НСтр("ru='и еще %1 значений'"), 
					ОсталосьВывестиЗначений);
				
				ПредставлениеКонстанты = ПредставлениеКонстанты + Символы.ПС + ПредставлениеЭлемента;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Возврат ПредставлениеКонстанты;

КонецФункции

&НаСервереБезКонтекста
Функция ЭтоКонстантаБезРазреза(ДанныеКонстанты)
	Возврат ДанныеКонстанты.ТипРазреза.Типы().Количество() = 0;	
КонецФункции
	
&НаСервереБезКонтекста
Функция ПредставлениеТипаРазреза(ОписаниеТипов)

	Если ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Организации") Тогда
		Возврат "организаций";
	Иначе
		Возврат Строка(ОписаниеТипов);
	КонецЕсли;

КонецФункции

&НаСервереБезКонтекста
Функция ПустоеЗначениеТипаРазреза(ОписаниеТипов)

	Если ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Организации") Тогда
		Возврат ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура КонстантаНажатиеВводЗначенийПоРазрезуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонстантаНажатиеВводЗначенийПоРазрезуЗавершениеСервер(Результат, ДополнительныеПараметры.ДанныеКонстанты);
	
КонецПроцедуры

&НаСервере
Процедура КонстантаНажатиеВводЗначенийПоРазрезуЗавершениеСервер(Результат, ДанныеКонстанты)

	Если ЗначениеЗаполнено(ДанныеКонстанты.ИмяФормы) Тогда
		
		Если ЗначениеЗаполнено(Результат) Тогда
			ЭтотОбъект[ДанныеКонстанты.Идентификатор] = Результат;
		КонецЕсли;
		
	Иначе
		
		Если Не ЭтоАдресВременногоХранилища(Результат) Тогда
			Возврат;	
		КонецЕсли;
		
		ЗначенияКонстантыРезультат = ПолучитьИзВременногоХранилища(Результат);
		
		// Удалить старые строки значений константы.
		ПараметрыПоиска = Новый Структура("Идентификатор", ДанныеКонстанты.Идентификатор);
		СтарыеСтрокиЗначенияКонстант = ЗначенияКонстант.НайтиСтроки(ПараметрыПоиска);
		Для каждого СтрокаЗначенияКонстанты Из СтарыеСтрокиЗначенияКонстант Цикл
			ЗначенияКонстант.Удалить(СтрокаЗначенияКонстанты);
		КонецЦикла;
		
		// Добавить новые строки значений константы.
		Для каждого СтрокаЗначенияКонстанты Из ЗначенияКонстантыРезультат Цикл
			НоваяСтрока = ЗначенияКонстант.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗначенияКонстанты);
		    НоваяСтрока.Идентификатор = ДанныеКонстанты.Идентификатор;
		КонецЦикла;
		
		// Обновить заголовок константы.
		ЭтотОбъект[ДанныеКонстанты.Идентификатор] = ПредставлениеКонстантыСРазрезом(
			ДанныеКонстант,
			ЗначенияКонстант,
			ДанныеКонстанты.Идентификатор,
			ДанныеКонстанты);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

