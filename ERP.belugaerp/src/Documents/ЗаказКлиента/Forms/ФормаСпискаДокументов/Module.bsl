#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)

	бг_ИзменитьТекстЗапросаСписка();
	бг_ДобавитьКомандуЗаполнитьУпаковки();
	бг_ДобавитьКомандуОбработатьЗаказыEDI();
	бг_ДобавитьКомандуАктуализироватьОбеспечение();
	бг_ДобавитьКомандуПеренестиДатуОтгрузки();
	бг_ДобавитьКомандуПередатьЗаказКлиентаВСборку();
	бг_ДобавитьКомандуРассчитатьСкидкиНаценки();
	бг_ДобавитьКомандуСоздатьЗаказыМагазина();
	бг_ДобавитьКомандуЗакрытьЗаказыПоНомерамИзФайлаExcel();
	бг_ДобавитьЭлементыФормы();
	бг_УстановитьВидимостьЭлементовРезервирования();
	бг_ОтключитьПолнотекстовыйПоискСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_РассчитатьСкидкиНаценки(Команда)
	
	ОчиститьСообщения();
	бг_РассчитатьСкидкиНаценкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СоздатьЗаказыМагазина(Команда)
	
	ОчиститьСообщения();
	бг_СоздатьЗаказыМагазинаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗакрытьЗаказыПоНомерамИзФайлаExcel(Команда)
	
	ОчиститьСообщения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("бг_ПослеВыбораФайлаExcelДляЗакрытияЗаказов", ЭтотОбъект);
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр		   = "Файл Excel (*.xlsx, *.xls)|*.xls;*.xlsx;";
	ДиалогОткрытияФайла.Заголовок	   = "Выберите файл Excel";
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьКомандуЗаполнитьУпаковки()
	
	Если Не Пользователи.РолиДоступны("бг_ИспользованиеОбработкиПоЗаполнениюУпаковокВЗаказахКлиентов") Тогда
		Возврат;
	КонецЕсли;
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СписокЗаполнитьУпаковки",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Заполнить упаковки'"),
		"бг_СписокЗаполнитьУпаковки",
		"бг_СписокЗаполнитьУпаковки",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СписокЗаполнитьУпаковки(Команда)
	
	ОбъектыНазначения = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
	
	бг_ЗаполнитьУпаковки(ОбъектыНазначения);
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьУпаковки(ОбъектыНазначения)
	
	Если ОбъектыНазначения.Количество() Тогда
		Обработка = Обработки.бг_ЗаполнитьУпаковки.Создать();
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ЭтаФорма", ЭтаФорма);
		Обработка.ВыполнитьКоманду("ЗаполнитьУпаковкиВДокументах", ОбъектыНазначения, ПараметрыВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуОбработатьЗаказыEDI()
	
	Если Не Пользователи.РолиДоступны("бг_ИспользованиеОбработкиОбработкаЗаказовEDI") Тогда
		Возврат;
	КонецЕсли;
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СписокОбработатьЗаказыEDI",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Обработать заказы EDI'"),
		"бг_СписокОбработатьЗаказыEDI",
		"бг_СписокОбработатьЗаказыEDI",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СписокОбработатьЗаказыEDI(Команда)
	
	ОбъектыНазначения = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
	
	бг_ПослеОбработкиЗаказовEDI = Новый ОписаниеОповещения("бг_ПослеОбработкиЗаказовEDI", ЭтаФорма, ОбъектыНазначения);
	
	ОткрытьФорму(
		"Обработка.бг_ОбработкаЗаказовEDI.Форма.Форма",
		Новый Структура("ОбъектыНазначения", ОбъектыНазначения),
		ЭтаФорма, 
		Истина,
		,
		,
		бг_ПослеОбработкиЗаказовEDI,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ПослеОбработкиЗаказовEDI(Результат, ДополнительныеПараметры) Экспорт
	
	Для Каждого ЗаказКлиента Из ДополнительныеПараметры Цикл
		ОповеститьОбИзменении(ЗаказКлиента);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуАктуализироватьОбеспечение()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СписокАктуализироватьОбеспечение",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Актуализировать обеспечение'"),
		"бг_СписокАктуализироватьОбеспечение",
		"бг_СписокАктуализироватьОбеспечение",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуПередатьЗаказКлиентаВСборку()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СписокПередатьЗаказКлиентаВСборку",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Передать в сборку'"),
		"бг_СписокПередатьЗаказКлиентаВСборку",
		"бг_СписокПередатьЗаказКлиентаВСборку",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СписокАктуализироватьОбеспечение(Команда)
	
	ОчиститьСообщения();
	ПараметрыОжидания = бг_ЗаказыКлиентовКлиент.ПараметрыОжиданияАктуализацииОбеспечения(ЭтотОбъект);
	ПараметрыОперации = Новый Структура("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ДлительнаяОперация = бг_АктуализироватьОбеспечениеВФоне(ПараметрыОперации);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		ДлительнаяОперация,
		Новый ОписаниеОповещения("бг_ОбработатьРезультатАктуализацииОбеспечения", ЭтотОбъект),
		ПараметрыОжидания);
	
КонецПроцедуры

// Запускает длительную операцию актуализации обеспечения на сервере.
//
&НаСервере
Функция бг_АктуализироватьОбеспечениеВФоне(Знач ПараметрыОперации) 
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ПараметрыВыполнения.Вставить("НаименованиеФоновогоЗадания", 
									НСтр("ru = 'Актуализация обеспечения заказов клиентов'"));
	ПараметрыВыполнения.Вставить("КлючФоновогоЗадания", ПараметрыОперации.УникальныйИдентификатор);
	
	ЗаказыКлиентов = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(
				ПараметрыВыполнения,
				"бг_ЗаказыКлиентов.АктуализироватьОбеспечениеЗаказовКлиентовВФоне",
				ЗаказыКлиентов);
	
КонецФункции

// Обработка результата длительной операции актуализации обеспечения.
//
// Параметры:
//  Результат               - Структура, Неопределено - результат выполнения длительной операции.  
//  ДополнительныеПараметры - Произвольный - Значение любого типа, которое передано при вызове. 
//
&НаКлиенте
Процедура бг_ОбработатьРезультатАктуализацииОбеспечения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	бг_ОбработатьРезультатАктуализацииОбеспеченияНаСервере(Результат);
	
	Если Результат.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Обеспечение';
				|en = 'Обеспечение'"), ,
			НСтр("ru = 'Актуализация обеспечения выполнена';
				|en = 'Актуализация обеспечения выполнена'"),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Обработка результата длительной операции актуализации обеспечения на сервере.
//
&НаСервере
Процедура бг_ОбработатьРезультатАктуализацииОбеспеченияНаСервере(Результат)
	
	бг_ОбработатьРезультатВыполненияВФонеНаСервере(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СписокПередатьЗаказКлиентаВСборку(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Заголовок = НСтр("ru = 'Передача заказов на сборку';
										|en = 'Передача заказов на сборку'");
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ДлительнаяОперация = бг_ПередатьЗаказыКлиентовВСборкуВФоне(ПараметрыОперации);
	
	ВыполнениеОперацииЗавершение = 
		Новый ОписаниеОповещения("бг_ОбработатьРезультатПередачиЗаказовКлиентовВСборку", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		ДлительнаяОперация,
		ВыполнениеОперацииЗавершение,
		ПараметрыОжидания);

КонецПроцедуры

// Запускает длительную операцию передачи заказов клиентов в сборку на сервере.
//
&НаСервере
Функция бг_ПередатьЗаказыКлиентовВСборкуВФоне(Знач ПараметрыОперации)
	
	ОбъектыНазначения = ОбщегоНазначения.СкопироватьРекурсивно(Элементы.Список.ВыделенныеСтроки);
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектыНазначения", ОбъектыНазначения);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗначенияКонстант.Разрез КАК Организация
	|ПОМЕСТИТЬ ЗапрещенаПередачаВСборкуБезСогласования
	|ИЗ
	|	(ВЫБРАТЬ
	|		бг_ДополнительныеКонстанты.Идентификатор КАК Идентификатор,
	|		ЕСТЬNULL(бг_ЗначенияДополнительныхКонстант.Значение, НЕОПРЕДЕЛЕНО) КАК Значение,
	|		ЕСТЬNULL(бг_ЗначенияДополнительныхКонстант.Разрез, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Разрез
	|	ИЗ
	|		Справочник.бг_ДополнительныеКонстанты КАК бг_ДополнительныеКонстанты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бг_ЗначенияДополнительныхКонстант КАК бг_ЗначенияДополнительныхКонстант
	|			ПО (бг_ЗначенияДополнительныхКонстант.Константа = бг_ДополнительныеКонстанты.Ссылка)
	|	ГДЕ
	|		бг_ДополнительныеКонстанты.Идентификатор = ""ЗапретПередачиВСборкуБезСогласованияПоОрганизации""
	|		И бг_ЗначенияДополнительныхКонстант.Значение = ИСТИНА) КАК ЗначенияКонстант
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказыКлиентов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ЗаказыКлиентов.Организация В (ЗапрещенаПередачаВСборкуБезСогласования.Организация)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК РазрешенаСборка
	|ПОМЕСТИТЬ ЗаказыКлиентов
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказыКлиентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗапрещенаПередачаВСборкуБезСогласования КАК ЗапрещенаПередачаВСборкуБезСогласования
	|		ПО ЗаказыКлиентов.Организация = ЗапрещенаПередачаВСборкуБезСогласования.Организация
	|ГДЕ
	|	ЗаказыКлиентов.Ссылка В(&ОбъектыНазначения)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	бг_СогласованиеЗаказовКлиентов.ЗаказКлиента,
	|	ВЫБОР
	|		КОГДА бг_СогласованиеЗаказовКлиентов.РезультатСогласования В
	|		(ЗНАЧЕНИЕ(Перечисление.бг_РезультатыСогласования.Согласовано),
	|		ЗНАЧЕНИЕ(Перечисление.бг_РезультатыСогласования.АвтоСогласование), 
	|		ЗНАЧЕНИЕ(Перечисление.бг_РезультатыСогласования.СогласованоПринудительно))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	РегистрСведений.бг_СогласованиеЗаказовКлиентов КАК бг_СогласованиеЗаказовКлиентов
	|ГДЕ
	|	бг_СогласованиеЗаказовКлиентов.ЗаказКлиента В(&ОбъектыНазначения)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыКлиентов.Ссылка КАК Ссылка,
	|	МАКСИМУМ(ЗаказыКлиентов.РазрешенаСборка) КАК РазрешенаСборка
	|ИЗ
	|	ЗаказыКлиентов КАК ЗаказыКлиентов
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыКлиентов.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	ЗаказыКлиентов = Новый Массив;
	ШаблонСообщения = НСтр("ru = 'Документ %1 не передан в сборку. Требуется согласование.'");
	Пока Выборка.Следующий() Цикл
		Если Выборка.РазрешенаСборка Тогда
			ЗаказыКлиентов.Добавить(Выборка.Ссылка);
		Иначе
			ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.Ссылка); 
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла; 
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	ПараметрыВыполнения.Вставить("НаименованиеФоновогоЗадания", НСтр("ru = 'Передача заказов клиентов на сборку'"));
	ПараметрыВыполнения.Вставить("КлючФоновогоЗадания", ПараметрыОперации.УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(
				ПараметрыВыполнения,
				"бг_ЗаказыКлиентов.ПередатьЗаказыКлиентовНаСборкуВФоне",
				ЗаказыКлиентов,
				Истина);
	
КонецФункции

// Обработка результата длительной операции передачи заказов клиентов в сборку.
//
// Параметры:
//  Результат               - Структура, Неопределено - результат выполнения длительной операции.  
//  ДополнительныеПараметры - Произвольный - Значение любого типа, которое передано при вызове. 
//
&НаКлиенте
Процедура бг_ОбработатьРезультатПередачиЗаказовКлиентовВСборку(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	бг_ОбработатьРезультатПередачиЗаказовКлиентовВСборкуНаСервере(Результат);
	
	Если Результат.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Передача в сборку';
				|en = 'Передача в сборку'"), ,
			НСтр("ru = 'Передача в сборку выполнена';
				|en = 'Передача в сборку выполнена'"),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Обработка результата длительной операции передачи заказов клиентов в сборку на сервере.
//
&НаСервере
Процедура бг_ОбработатьРезультатПередачиЗаказовКлиентовВСборкуНаСервере(Результат)
	
	бг_ОбработатьРезультатВыполненияВФонеНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуРассчитатьСкидкиНаценки()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_РассчитатьСкидкиНаценки",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Рассчитать скидки (наценки)'"),
		"бг_РассчитатьСкидкиНаценки",
		"бг_РассчитатьСкидкиНаценки",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаСервере
Процедура бг_РассчитатьСкидкиНаценкиНаСервере()
	
	ОбъектыНазначения = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
	                    
	Для Каждого ДокументСсылка Из ОбъектыНазначения Цикл
		Попытка
			ДокументОбъект = ДокументСсылка.ПолучитьОбъект();

			СтруктураПараметры = СкидкиНаценкиЗаполнениеСервер.НовыйПараметрыРассчитать();
			СтруктураПараметры.ПрименятьКОбъекту				 = Истина;
			СтруктураПараметры.ТолькоПредварительныйРасчет		 = Ложь;
			ПримененныеСкидки = СкидкиНаценкиЗаполнениеСервер.Рассчитать(ДокументОбъект, СтруктураПараметры);
			ДокументОбъект.Записать(?(ДокументОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
		Исключение
			ОбщегоНазначения.СообщитьПользователю(
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
				ДокументСсылка);
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуСоздатьЗаказыМагазина()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СоздатьЗаказыМагазина",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Создать заказы магазина'"),
		"бг_СоздатьЗаказыМагазина",
		"бг_СоздатьЗаказыМагазина",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаСервере
Процедура бг_СоздатьЗаказыМагазинаНаСервере()
	
	ОбъектыНазначения = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(Элементы.Список.ВыделенныеСтроки);
	                    
	Для Каждого ДокументСсылка Из ОбъектыНазначения Цикл
		Результат = бг_ЗаказыКлиентов.СоздатьЗаказМагазина(ДокументСсылка);
		Если Результат.ОписаниеОшибки <> "" Тогда
			ОбщегоНазначения.СообщитьПользователю(
				Результат.ОписаниеОшибки,
				ДокументСсылка);
			Продолжить;
		КонецЕсли;
		
		РеквизитыЗаказаМагазина = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Результат.ЗаказМагазина, "Дата, Номер");
		ОбщегоНазначения.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Создан заказ магазина номер %1 дата %2'"), 
			РеквизитыЗаказаМагазина.Номер, РеквизитыЗаказаМагазина.Дата),
			ДокументСсылка);
	КонецЦикла;

	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьКомандуЗакрытьЗаказыПоНомерамИзФайлаExcel()
	
	Если Не Пользователи.РолиДоступны("бг_ИспользованиеКомандыЗакрытьЗаказыПоНомерамИзФайлаExcel") Тогда
		Возврат;
	КонецЕсли;
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_ЗакрытьЗаказыПоНомерамИзФайлаExcel",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Закрыть заказы по номерам из файла Excel'"),
		"бг_ЗакрытьЗаказыПоНомерамИзФайлаExcel",
		"бг_ЗакрытьЗаказыПоНомерамИзФайлаExcel",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ПослеВыбораФайлаExcelДляЗакрытияЗаказов(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	Если Не ЗначениеЗаполнено(ВыбранныеФайлы) Тогда
		Возврат;	
	КонецЕсли;	
	
	ПутьКФайлу = ВыбранныеФайлы.Получить(0);
	
	НомераЗаказов = бг_НомераЗаказовПоФайлуExcel(ПутьКФайлу);
	Заказы = бг_ЗаказыКлиентовПоНомерам(НомераЗаказов);
	
	бг_ЗакрытьЗаказы(Заказы);
	
КонецПроцедуры

&НаКлиенте
Функция бг_НомераЗаказовПоФайлуExcel(ПутьКФайлу)

	Excel = Новый COMObject("Excel.Application");
	Книга = Excel.Workbooks;
	Книга.Open(ПутьКФайлу);
	
	Версия = Лев(Excel.Version, Найти(Excel.Version,".") - 1);
	
	Если Версия = "8" тогда
		ФайлСтрок   = Excel.Cells.CurrentRegion.Rows.Count;
	Иначе
		ФайлСтрок   = Excel.Cells(1, 1).SpecialCells(11).Row;
	Конецесли;
	
	НомераЗаказов = Новый СписокЗначений;
	
	Для НомерСтроки = 1 По ФайлСтрок Цикл 
		НомерЗаказа = СокрЛП(Excel.Cells(НомерСтроки, 1).Text);
		Если ЗначениеЗаполнено(НомерЗаказа) Тогда
			НомераЗаказов.Добавить(НомерЗаказа);	
		КонецЕсли;
	КонецЦикла;
	
	Возврат НомераЗаказов;
	
КонецФункции

&НаКлиенте
Процедура бг_ЗакрытьЗаказы(Заказы)

	Если Заказы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось найти заказы по выбранному файлу'"));
		Возврат;
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(Заказы);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
		ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
КонецПроцедуры

&НаСервере
Функция бг_ЗаказыКлиентовПоНомерам(НомераЗаказов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказКлиента.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТ_ЗаказыКлиентов
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	НЕ ЗаказКлиента.ПометкаУдаления
		|	И ЗаказКлиента.Номер В(&НомераЗаказов)
		|	И НАЧАЛОПЕРИОДА(ЗаказКлиента.Дата, ГОД) = &ТекущийГод
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	НЕ ЗаказКлиента.ПометкаУдаления
		|	И ЗаказКлиента.бг_НомерДокументаУПП В(&НомераЗаказов)
		|	И НАЧАЛОПЕРИОДА(ЗаказКлиента.Дата, ГОД) = &ТекущийГод
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	НЕ ЗаказКлиента.ПометкаУдаления
		|	И ЗаказКлиента.НомерПоДаннымКлиента В(&НомераЗаказов)
		|	И НАЧАЛОПЕРИОДА(ЗаказКлиента.Дата, ГОД) = &ТекущийГод
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_ЗаказыКлиентов.Ссылка КАК Ссылка
		|ИЗ
		|	ВТ_ЗаказыКлиентов КАК ВТ_ЗаказыКлиентов";
	
	Запрос.УстановитьПараметр("НомераЗаказов", НомераЗаказов);
	Запрос.УстановитьПараметр("ТекущийГод", НачалоГода(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьКомандуПеренестиДатуОтгрузки()
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект,
		"бг_СписокПеренестиДатуОтгрузки",
		Элементы.ГруппаДействия,
		НСтр("ru = 'Перенести дату отгрузки'"),
		"бг_СписокПеренестиДатуОтгрузки",
		"бг_СписокПеренестиДатуОтгрузки",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_СписокПеренестиДатуОтгрузки(Команда)

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("бг_СписокПеренестиДатуОтгрузкиЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ЗаказКлиента.Форма.бг_ФормаЗаполненияПричиныПереносаДатыОтгрузки", 
		,
		,
		,
		,
		,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Процедура бг_СписокПеренестиДатуОтгрузкиЗавершение(ВозвращенноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ВозвращенноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыНазначения = ОбщегоНазначения.СкопироватьРекурсивно(Элементы.Список.ВыделенныеСтроки);
	                    
	РеквизитыЗаказов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ОбъектыНазначения, "ДатаОтгрузки,бг_ИсточникЗаказа");
	
	Для Каждого ДокументСсылка Из ОбъектыНазначения Цикл
		
		РеквизитыЗаказа = РеквизитыЗаказов.Получить(ДокументСсылка); 
		Если РеквизитыЗаказа.ДатаОтгрузки = ВозвращенноеЗначение.ДатаОтгрузки Тогда
			Продолжить;
		КонецЕсли;
		Если РеквизитыЗаказа.бг_ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.WINELAB_HYBRIS Тогда
			// Не меняем дату отгрузки в интернет-заказах, так как резерв 
			// по текущей дате отгрузки уже мог быть сторнирован в консолидированном заказе.  
			Продолжить;
		КонецЕсли;

		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.бг_ПричинаПереносаДатыОтгрузки 	= ВозвращенноеЗначение.ПричинаПереносаДатыОтгрузки;
		ДокументОбъект.ДатаОтгрузки 					= ВозвращенноеЗначение.ДатаОтгрузки;		
		
		Если ДокументОбъект.Проведен Тогда 
			Попытка 
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
					НСтр("ru = 'Групповой перенос даты отгрузки в заказе клиента'"), 
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		Иначе
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыФормы()
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_ДолгосрочныйРезерв",
						Элементы.Список,
						"Список.Ссылка.бг_ДолгосрочныйРезерв",
						, // Тип поля, строка
						Элементы.СписокСуммаДокумента, // Элемент перед которым будет вставлен создаваемый элемент
						"ПолеФлажка");
	
	ЭлементФормы.Заголовок = НСтр("ru = 'ДР'");
	ЭлементФормы.Подсказка = НСтр("ru = 'Долгосрочный резерв'");

	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.бг_СогласованиеЗаказовКлиентов) Тогда
		
		ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_РезультатСогласования",
						Элементы.Список,
						"Список.бг_РезультатСогласования",,
						Элементы.СписокСтатус); 
						
		ЭлементФормы.Заголовок = НСтр("ru = 'Cогласование'");
	
		ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_ДатаПередачиВСборку",
						Элементы.Список,
						"Список.бг_ДатаПередачиВСборку",,
						Элементы.СписокСтатус); 
						
		ЭлементФормы.Заголовок = НСтр("ru = 'Дата передачи в сборку'");
		
		ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_ДатаСборки",
						Элементы.Список,
						"Список.бг_ДатаСборки",,
						Элементы.СписокСтатус); 
						
		ЭлементФормы.Заголовок = НСтр("ru = 'Дата сборки'");
		
		ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_Закрыт",
						Элементы.Список,
						"Список.бг_Закрыт",,
						Элементы.СписокСтатус,
						"ПолеФлажка"); 
						
		ЭлементФормы.Заголовок = НСтр("ru = 'Закрыт в УПП'");
		
		
	КонецЕсли;
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"бг_ПолныйРезерв",
						Элементы.Список,
						"Список.Ссылка.бг_ПолныйРезерв",
						, // Тип поля, строка
						Элементы.СписокСуммаДокумента, // Элемент перед которым будет вставлен создаваемый элемент
						"ПолеФлажка");
	
	ЭлементФормы.Заголовок = НСтр("ru = 'ПР'");
	ЭлементФормы.Подсказка = НСтр("ru = 'Полный резерв'");
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"ЗаказРозничногоПокупателя",
						Элементы.Список,
						"Список.бг_ЗаказРозничногоПокупателя",
						, 
						, 
						"ПолеФлажка");
	
	ЭлементФормы.Заголовок = НСтр("ru = 'Розничный покупатель'");
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
						ЭтотОбъект,
						"ЗаказМагазина",
						Элементы.Список,
						"Список.бг_ЗаказМагазина",
						, 
						, 
						"ПолеФлажка");
	
	ЭлементФормы.Заголовок = НСтр("ru = 'Магазин'");
	
	Если ПравоДоступа("Просмотр", Метаданные.Документы.битМаршрутныйЛист) Тогда
		
		ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
							ЭтотОбъект,
							"бг_МаршрутныйЛист",
							Элементы.Список,
							"Список.бг_МаршрутныйЛист",,
							Элементы.бг_РезультатСогласования);
		ЭлементФормы.Заголовок = НСтр("ru = 'Маршрутный лист'");
	
	КонецЕсли;
	
	ЭлементФормы = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ЗаполненаОрганизацияЕГАИС",
		Элементы.Список,
		"Список.бг_ЗаполненаОрганизацияЕГАИС",,
		Элементы.СписокСтатус,
		"ПолеФлажка");	
	ЭлементФормы.Заголовок = НСтр("ru = 'Заполнена организация ЕГАИС'");

КонецПроцедуры

&НаСервере
Процедура бг_УстановитьВидимостьЭлементовРезервирования()
	
	// Удалим из команд обеспечения вариант "Резервировать по мере поступления", так как его не используем.
	Элементы.СписокРезервироватьПоМереПоступленияЗаказ.Видимость = Ложь;
	
КонецПроцедуры	

&НаСервере
Процедура бг_ИзменитьТекстЗапросаСписка()
	
	ТекстЗапроса = Список.ТекстЗапроса;
	
	ПозцияСлова = СтрНайти(ТекстЗапроса, СтрШаблон("%1%2%3", Символы.ПС, "ИЗ", Символы.ПС), НаправлениеПоиска.СКонца);
	Если ПозцияСлова > 0 Тогда
		
		ТекстЗапросаДоВставляемойСтроки = Лев(ТекстЗапроса, ПозцияСлова - 1);
		ТекстЗапросаПослеВставляемойСтроки = Сред(ТекстЗапроса, ПозцияСлова);
		ВставляемаяСтрока =
		",
		|	бг_СогласованиеЗаказовКлиентов.РезультатСогласования КАК бг_РезультатСогласования,
		|	НАЧАЛОПЕРИОДА(бг_СогласованиеЗаказовКлиентов.ДатаПередачиВСборку, ДЕНЬ) КАК бг_ДатаПередачиВСборку,
		|	НАЧАЛОПЕРИОДА(бг_СогласованиеЗаказовКлиентов.ДатаСборки, ДЕНЬ) КАК бг_ДатаСборки,
		|	бг_СогласованиеЗаказовКлиентов.Закрыт КАК бг_Закрыт,
		|	ВЫБОР
		|		КОГДА ДокументЗаказКлиента.бг_ПунктНазначения.ОрганизацияЕГАИС = ЗНАЧЕНИЕ(Справочник.КлассификаторОрганизацийЕГАИС.ПустаяСсылка)
		|		ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК бг_ЗаполненаОрганизацияЕГАИС";
		
		ТекстЗапроса = СтрШаблон(
			"%1%2%3",
			ТекстЗапросаДоВставляемойСтроки,
			ВставляемаяСтрока, 
			ТекстЗапросаПослеВставляемойСтроки);
			
	КонецЕсли;
	
	СтрокаПоиска = "ПО (СостоянияЭД.СсылкаНаОбъект = ДокументЗаказКлиента.Ссылка)}";
	СтрокаЗамены = СтрШаблон(
		"%1%2",
		СтрокаПоиска, 
		"
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бг_СогласованиеЗаказовКлиентов КАК бг_СогласованиеЗаказовКлиентов
		|		ПО (бг_СогласованиеЗаказовКлиентов.ЗаказКлиента = ДокументЗаказКлиента.Ссылка)"); 
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		СтрокаПоиска,
		СтрокаЗамены);
		
	СтрокаПоиска = "ИЗ
		|	Документ.ЗаказКлиента КАК ДокументЗаказКлиента";
	
	СтрокаЗамены = СтрШаблон(
		",
		|	ВЫБОР
		|		КОГДА ДокументЗаказКлиента.бг_Магазин <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|				И ДокументЗаказКлиента.бг_ЗаказРозничногоПокупателя = ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК бг_ЗаказРозничногоПокупателя,
		|	ВЫБОР
		|		КОГДА ДокументЗаказКлиента.бг_Магазин <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|				И ДокументЗаказКлиента.бг_ЗаказРозничногоПокупателя <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК бг_ЗаказМагазина
		|%1", СтрокаПоиска);
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		СтрокаПоиска,
		СтрокаЗамены);
	
	Если ПравоДоступа("Просмотр", Метаданные.Документы.битМаршрутныйЛист) Тогда
		
		// Добавляем временную таблицу "бг_МаршрутныеЛисты" в начало пакета.
		ТекстЗапроса = СтрШаблон(
			"%1
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|%2",
			бг_ТекстЗапросаВременнаяТаблицаМаршрутныеЛисты(),
				ТекстЗапроса);
				
		// Добавляем соединение с временной таблицей "бг_втМаршрутныеЛисты" в результирующий пакет запроса.
		СтрокаПоиска = 
			"КОНЕЦ КАК бг_ЗаказМагазина";
		СтрокаЗамены = СтрШаблон("%1", 
			"КОНЕЦ КАК бг_ЗаказМагазина,
			|	бг_МаршрутныеЛисты.бг_МаршрутныйЛист КАК бг_МаршрутныйЛист"); 
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			СтрокаПоиска,
			СтрокаЗамены);
				
		СтрокаПоиска = 
			"ПО (бг_СогласованиеЗаказовКлиентов.ЗаказКлиента = ДокументЗаказКлиента.Ссылка)";
		СтрокаЗамены = СтрШаблон("%1 %2", СтрокаПоиска, 
			"	ЛЕВОЕ СОЕДИНЕНИЕ бг_МаршрутныеЛисты КАК бг_МаршрутныеЛисты
			|	ПО ДокументЗаказКлиента.Ссылка = бг_МаршрутныеЛисты.ЗаказКлиента"); 
		ТекстЗапроса = СтрЗаменить(
			ТекстЗапроса,
			СтрокаПоиска,
			СтрокаЗамены);

	КонецЕсли;		

	Список.ТекстЗапроса = ТекстЗапроса;
	
КонецПроцедуры

&НаСервере
Функция бг_ТекстЗапросаВременнаяТаблицаМаршрутныеЛисты()
	
	Возврат
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(ЕСТЬNULL(битМаршрутныйЛистЗаказы.Ссылка, ЗНАЧЕНИЕ(Документ.битМаршрутныйЛист.ПустаяСсылка))) КАК бг_МаршрутныйЛист,
		|	битМаршрутныйЛистЗаказы.Заказ КАК ЗаказКлиента
		|ПОМЕСТИТЬ бг_МаршрутныеЛисты
		|ИЗ
		|	Документ.битМаршрутныйЛист.Заказы КАК битМаршрутныйЛистЗаказы
		|ГДЕ
		|	битМаршрутныйЛистЗаказы.Ссылка.ВидДокумента = ЗНАЧЕНИЕ(Перечисление.бг_ВидыМаршрутныхЛистов.МаршрутныйЛист)
		|	И НЕ битМаршрутныйЛистЗаказы.Ссылка.ПометкаУдаления
		|	И битМаршрутныйЛистЗаказы.Ссылка.Проведен
		|СГРУППИРОВАТЬ ПО
		|	битМаршрутныйЛистЗаказы.Заказ";
	
КонецФункции

// Обработка результата длительной операции передачи заказов клиентов в сборку на сервере.
//
&НаСервере
Процедура бг_ОбработатьРезультатВыполненияВФонеНаСервере(Результат)
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для Каждого Сообщение Из Результат.Сообщения Цикл
			Сообщение.ИдентификаторНазначения = УникальныйИдентификатор;
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ОтключитьПолнотекстовыйПоискСписка()

 	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ОтключитьПолнотекстовыйПоискСпискаФормы(
		Элементы.Список);
	
КонецПроцедуры

#КонецОбласти
