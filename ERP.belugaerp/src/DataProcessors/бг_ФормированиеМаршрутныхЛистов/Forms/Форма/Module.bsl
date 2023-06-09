#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьФорму();
	ОбновитьСтатусыЗаказовСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПараметрыДинамическихСписков();
	
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗаказКлиента" 
		Или ИмяСобытия = "Запись_ЗаказПоставщику" 
		Или ИмяСобытия = "Запись_ЗаказНаПеремещение" Тогда
		ОбновитьТаблицуНераспределенныеЗаказыСервер();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрСтатусыЗаказовПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрСогласованиеПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрНераспределенныхЗаказовПриИзменении(Элемент)
	ФильтрНераспределенныхЗаказовПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрВидПеревозкиПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаСервере
Процедура ФильтрНераспределенныхЗаказовПриИзмененииСервер()
	Если ФильтрНераспределенныхЗаказов <> "ЗаказКлиента" Тогда
		Элементы.ФильтрСогласование.Доступность = Ложь;
		Элементы.ФильтрДатаДоставки.Доступность = Ложь;
		ФильтрСогласование = 0;
	Иначе
		Элементы.ФильтрСогласование.Доступность = Истина;
		Элементы.ФильтрДатаДоставки.Доступность = Истина;
	КонецЕсли;
	
	ОбновитьСтатусыЗаказовСервер();
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПериодФормированияПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТранзитПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаКлиенте
Процедура ФильтрДатаДоставкиПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНераспределенныеЗаказыНастройкиОтборПриИзменении(Элемент)
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказы

&НаКлиенте
Процедура ЗаказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	МассивЗаказы = Новый Массив;
	МассивЗаказы.Добавить(Элементы.Заказы.ДанныеСтроки(ВыбраннаяСтрока).Заказ);
	
	УбратьЗаказИзМаршрутногоЛистаСервер(МассивЗаказы, Элементы.МаршрутныеЛисты.ТекущаяСтрока);
	Элементы.МаршрутныеЛисты.Обновить();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМаршрутныеЛисты

&НаКлиенте
Процедура МаршрутныеЛистыПриАктивизацииСтроки(Элемент)
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНераспределенныеЗаказы

&НаКлиенте
Процедура НераспределенныеЗаказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтрокиЗаказов = Новый Массив;
	СтрокиЗаказов.Добавить(ВыбраннаяСтрока);
	ДобавитьЗаказВМаршрутСервер(Элементы.НераспределенныеЗаказы.ВыделенныеСтроки, Элементы.МаршрутныеЛисты.ТекущаяСтрока);
	
	Элементы.МаршрутныеЛисты.Обновить();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура НераспределенныеЗаказыПриАктивизацииСтроки(Элемент)
	НераспределенныеЗаказыСтрока = Элементы.НераспределенныеЗаказы.ТекущиеДанные;                       
	Если Не НераспределенныеЗаказыСтрока = Неопределено Тогда
		Элементы.НераспределенныеЗаказыАдресДоставки.Заголовок = НераспределенныеЗаказыСтрока.АдресДоставки;
	Иначе
		Элементы.НераспределенныеЗаказыАдресДоставки.Заголовок = "";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСписки(Команда)
	УстановитьПараметрыДинамическихСписков();
	
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура НераспределенныеЗаказыОтменитьПометку(Команда)
	УстановитьПометку(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура НераспределенныеЗаказыУстановитьПометку(Команда)
	УстановитьПометку(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаказВМаршрут(Команда)
	ДобавитьЗаказВМаршрутСервер(Элементы.НераспределенныеЗаказы.ВыделенныеСтроки, Элементы.МаршрутныеЛисты.ТекущаяСтрока);
	Элементы.МаршрутныеЛисты.Обновить();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура УбратьЗаказИзМаршрутногоЛиста(Команда) 
	МассивЗаказы = Новый Массив;
	Для каждого ИдентификаторСтроки Из Элементы.Заказы.ВыделенныеСтроки Цикл
		МассивЗаказы.Добавить(Элементы.Заказы.ДанныеСтроки(ИдентификаторСтроки).Заказ);
	КонецЦикла;
	УбратьЗаказИзМаршрутногоЛистаСервер(МассивЗаказы, Элементы.МаршрутныеЛисты.ТекущаяСтрока);
	Элементы.МаршрутныеЛисты.Обновить();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗаказыВМаршрут(Команда)
	ДобавитьЗаказыВМаршрутСервер(Элементы.МаршрутныеЛисты.ТекущаяСтрока);
	Элементы.МаршрутныеЛисты.Обновить();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоМаршрутам(Команда)
	Если Не ЗначениеЗаполнено(ПериодФормирования.ДатаОкончания) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не заполнена дата окончания периода'"));
		Возврат;
	КонецЕсли;
	РаспределитьПоМаршрутамНаСервере();
	ОбновитьТаблицуЗаказы();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьМаршрутныйЛист(Команда)
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	СоздатьНовыйМаршрутныйЛист(ДанныеЗаполнения);
	
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОтмененныеЗаказы(Команда)
	ВыделенныеСтроки = Элементы.МаршрутныеЛисты.ВыделенныеСтроки;
	УдалитьОтмененныеЗаказыНаСервере(ВыделенныеСтроки);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьСхемуКомпоновкиНераспределенныхЗаказов()
	ИмяМакета = "НераспределенныеЗаказы";
	СхемаКомпоновки = Обработки.бг_ФормированиеМаршрутныхЛистов.ПолучитьМакет(ИмяМакета);
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(СхемаКомпоновки , УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВоВременномХранилище);
	
	КомпоновщикНастроекНераспределенныеЗаказы.Инициализировать(ИсточникНастроек);
	
	КомпоновщикНастроекНераспределенныеЗаказы.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);		
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	ОбновитьТаблицуМаршрутыСервер();
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусыЗаказовСервер()
	ТекущееЗначение = ФильтрСтатусыЗаказов;
	СписокВыбора = Элементы.ФильтрСтатусыЗаказов.СписокВыбора;
	СписокВыбора.Очистить();
	Элементы.ФильтрСтатусыЗаказов.Доступность = Истина;
	
	Если ФильтрНераспределенныхЗаказов = "ЗаказКлиента" И 
		ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
		СписокВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.ПустаяСсылка(), "Все");
		СписокВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОбеспечению);
		СписокВыбора.Добавить(Перечисления.СтатусыЗаказовКлиентов.КОтгрузке);
	ИначеЕсли ФильтрНераспределенныхЗаказов = "ЗаказПоставщику" И 
		ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовПоставщикам") Тогда
		СписокВыбора.Добавить(Перечисления.СтатусыЗаказовПоставщикам.ПустаяСсылка(), "Все");
	ИначеЕсли ФильтрНераспределенныхЗаказов = "ЗаказНаПеремещение" И 
		ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовНаПеремещение") Тогда
		СписокВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.ПустаяСсылка(), "Все");
	Иначе
		Элементы.ФильтрСтатусыЗаказов.Доступность = Ложь;
		ФильтрСтатусыЗаказов = Неопределено;
	КонецЕсли;
	Если СписокВыбора.Количество() > 0 И СписокВыбора.НайтиПоЗначению(ТекущееЗначение) = Неопределено Тогда 
		ФильтрСтатусыЗаказов = СписокВыбора[0].Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуЗаказы()
	МаршрутныйЛист = Элементы.МаршрутныеЛисты.ТекущаяСтрока;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Заказы, "МаршрутныйЛист", МаршрутныйЛист, Истина);
	Элементы.Заказы.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуМаршрутыСервер()
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		МаршрутныеЛисты, "ПериодНачало", ПериодФормирования.ДатаНачала, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		МаршрутныеЛисты, "ПериодОкончание", ПериодФормирования.ДатаОкончания, Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		МаршрутныеЛисты, "ЕдиницаИзмеренияПаллета", бг_КонстантыПовтИсп.ЗначениеКонстанты("ЕдиницаПоКлассификаторуДляПаллеты"), Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		МаршрутныеЛисты, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно);
		
	Элементы.МаршрутныеЛисты.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуНераспределенныеЗаказыСервер()
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяМакета = "НераспределенныеЗаказы";
	СхемаКомпоновки = Обработки.бг_ФормированиеМаршрутныхЛистов.ПолучитьМакет(ИмяМакета);
	
	ЗначенияФильтраСогласованиеЗаказов = ЗначенияФильтраСогласованиеЗаказов();
	
	НастройкиКомпоновки = КомпоновщикНастроекНераспределенныеЗаказы.ПолучитьНастройки();
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("Организация", Организация);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаНачала", ПериодФормирования.ДатаНачала);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаОкончания", ПериодФормирования.ДатаОкончания);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("Фильтр", ФильтрНераспределенныхЗаказов);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ВидыПеревозкиСамовывоз",
											Справочники.бг_ВидыПеревозки.ВидыПеревозкиСамовывоз());
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕстьФильтрПоВидуПеревозки",
											ФильтрВидПеревозки <> "ВключаяСамовывоз");
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("Статус", ФильтрСтатусыЗаказов);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ИспользоватьОтборПоСтатусу",
											ЗначениеЗаполнено(ФильтрСтатусыЗаказов));
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоСогласованные",
											ФильтрСогласование = ЗначенияФильтраСогласованиеЗаказов.ТолькоСогласованные);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("СтатусыСогласовано",
											Перечисления.бг_РезультатыСогласования.СтатусыСогласовано());
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоЗакрытые",
											ФильтрСогласование = ЗначенияФильтраСогласованиеЗаказов.Закрытые);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("Транзит", ФильтрТранзит = 1);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ДоставкаНаСледующийДень", ФильтрДатаДоставки = 1);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра("ЕдиницаИзмеренияПаллета",
											бг_КонстантыПовтИсп.ЗначениеКонстанты("ЕдиницаПоКлассификаторуДляПаллеты"));
	
	КомпоновщикМакета   = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки     = КомпоновщикМакета.Выполнить(СхемаКомпоновки,
		НастройкиКомпоновки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Данные = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(Данные);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	НераспределенныеЗаказы.Загрузить(Данные);
КонецПроцедуры

&НаСервере
Функция ЗначенияФильтраСогласованиеЗаказов()
	ЗначенияФильтраСогласованиеЗаказов = Новый Структура;
	
	ЗначенияФильтраСогласованиеЗаказов.Вставить("Все", 0);
	ЗначенияФильтраСогласованиеЗаказов.Вставить("ТолькоСогласованные", 1);
	ЗначенияФильтраСогласованиеЗаказов.Вставить("Закрытые", 2);
	
	Возврат ЗначенияФильтраСогласованиеЗаказов;	
КонецФункции

&НаСервере
Процедура ИнициализироватьФорму()
	ПериодФормирования.ДатаНачала = НачалоДня(ТекущаяДатаСеанса());
	ПериодФормирования.ДатаОкончания = КонецДня(ПериодФормирования.ДатаНачала);
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	ИнициализироватьСхемуКомпоновкиНераспределенныхЗаказов();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Пометка)
	Для каждого СтрокаЗаказы Из НераспределенныеЗаказы Цикл 
		СтрокаЗаказы.Пометка = Пометка;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура РаспределитьПоМаршрутамНаСервере()
	Запрос = Новый Запрос;
	ИсходнаяТаблица = НераспределенныеЗаказы.Выгрузить(
		Новый Структура("Пометка", Истина),
		"Заказ, Маршрут, ПунктНазначения");
	Запрос.УстановитьПараметр("ИсходнаяТаблица", ИсходнаяТаблица);
	Запрос.УстановитьПараметр("КонецПериода", ПериодФормирования.ДатаОкончания);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Заказ КАК Заказ,
	|	Таблица.ПунктНазначения КАК ПунктНазначения,
	|	Таблица.Маршрут КАК Маршрут
	|ПОМЕСТИТЬ НераспределенныеЗаказы
	|ИЗ
	|	&ИсходнаяТаблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НераспределенныеЗаказы.Заказ КАК Заказ,
	|	НераспределенныеЗаказы.Маршрут КАК Маршрут,
	|	ВЫБОР
	|		КОГДА ПунктыНазначенияРП.ПунктНазначения ЕСТЬ NULL
	|			ТОГДА НераспределенныеЗаказы.ПунктНазначения
	|		ИНАЧЕ ПунктыНазначенияРП.ПунктНазначения
	|	КОНЕЦ КАК ПунктНазначения
	|ПОМЕСТИТЬ втДанные
	|ИЗ
	|	НераспределенныеЗаказы КАК НераспределенныеЗаказы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказМагазина.Ссылка КАК Заказ,
	|			ЗаказРозничногоПокупателя.бг_ПунктНазначения КАК ПунктНазначения
	|		ИЗ
	|			Документ.ЗаказКлиента КАК ЗаказМагазина
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК ЗаказРозничногоПокупателя
	|				ПО ЗаказМагазина.бг_ЗаказРозничногоПокупателя = ЗаказРозничногоПокупателя.Ссылка
	|					И (ЗаказМагазина.Ссылка В
	|						(ВЫБРАТЬ
	|							НераспределенныеЗаказы.Заказ
	|						ИЗ
	|							НераспределенныеЗаказы КАК НераспределенныеЗаказы))) КАК ПунктыНазначенияРП
	|		ПО НераспределенныеЗаказы.Заказ = ПунктыНазначенияРП.Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	битМаршрутныйЛист.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ втМаршрутныеЛисты
	|ИЗ
	|	Документ.битМаршрутныйЛист КАК битМаршрутныйЛист
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(битМаршрутныйЛист.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&КонецПериода, ДЕНЬ)
	|	И НЕ битМаршрутныйЛист.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	битМаршрутныйЛистЗаказы.Ссылка КАК Ссылка,
	|	битМаршрутныйЛистЗаказы.ПунктНазначения.Маршрут КАК Маршрут,
	|	СУММА(1) КАК КоличествоПунктовНазначения
	|ПОМЕСТИТЬ втДанныеПоМаршрутам
	|ИЗ
	|	Документ.битМаршрутныйЛист.Заказы КАК битМаршрутныйЛистЗаказы
	|ГДЕ
	|	битМаршрутныйЛистЗаказы.Ссылка В
	|			(ВЫБРАТЬ
	|				втМаршрутныеЛисты.Ссылка
	|			ИЗ
	|				втМаршрутныеЛисты КАК втМаршрутныеЛисты)
	|
	|СГРУППИРОВАТЬ ПО
	|	битМаршрутныйЛистЗаказы.Ссылка,
	|	битМаршрутныйЛистЗаказы.ПунктНазначения.Маршрут
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(втДанныеПоМаршрутам.Ссылка) КАК МаршрутныйЛист,
	|	ДанныеПоМаксимумам.Маршрут КАК Маршрут
	|ПОМЕСТИТЬ втМаршрутыДокументы
	|ИЗ
	|	(ВЫБРАТЬ
	|		втДанныеПоМаршрутам.Маршрут КАК Маршрут,
	|		МАКСИМУМ(втДанныеПоМаршрутам.КоличествоПунктовНазначения) КАК КоличествоМаксимум
	|	ИЗ
	|		втДанныеПоМаршрутам КАК втДанныеПоМаршрутам
	|	
	|	СГРУППИРОВАТЬ ПО
	|		втДанныеПоМаршрутам.Маршрут) КАК ДанныеПоМаксимумам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеПоМаршрутам КАК втДанныеПоМаршрутам
	|		ПО ДанныеПоМаксимумам.Маршрут = втДанныеПоМаршрутам.Маршрут
	|			И ДанныеПоМаксимумам.КоличествоМаксимум = втДанныеПоМаршрутам.КоличествоПунктовНазначения
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПоМаксимумам.Маршрут
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанные.Заказ КАК Заказ,
	|	втДанные.Маршрут КАК Маршрут,
	|	втДанные.ПунктНазначения КАК ПунктНазначения,
	|	ЕСТЬNULL(втМаршрутыДокументы.МаршрутныйЛист, ЗНАЧЕНИЕ(Документ.битМаршрутныйлист.ПустаяСсылка)) КАК МаршрутныйЛист
	|ИЗ
	|	втДанные КАК втДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ втМаршрутыДокументы КАК втМаршрутыДокументы
	|		ПО (втМаршрутыДокументы.Маршрут = втДанные.Маршрут)
	|ИТОГИ ПО
	|	Маршрут,
	|	МаршрутныйЛист";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаПоМаршрутам = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоМаршрутам.Следующий() Цикл
		ВыборкаПоДокументам = ВыборкаПоМаршрутам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоДокументам.Следующий() Цикл            
			Если ЗначениеЗаполнено(ВыборкаПоДокументам.МаршрутныйЛист) Тогда
				ДокументОбъект = ВыборкаПоДокументам.МаршрутныйЛист.ПолучитьОбъект();
			Иначе
				ДокументОбъект = Документы.битМаршрутныйЛист.СоздатьДокумент();
				ДокументОбъект.Заполнить(Неопределено);
				ДокументОбъект.ВидДокумента = Перечисления.бг_ВидыМаршрутныхЛистов.МаршрутныйЛист;
				ДокументОбъект.Дата = ПериодФормирования.ДатаОкончания;
				ДокументОбъект.Организация = Организация;
			КонецЕсли;
			ВыборкаПоЗаказам = ВыборкаПоДокументам.Выбрать();
			Пока ВыборкаПоЗаказам.Следующий() Цикл
				ДокументОбъект.ДобавитьЗаказ(ВыборкаПоЗаказам.Заказ, ВыборкаПоЗаказам.ПунктНазначения);
			КонецЦикла;
			ДокументОбъект.ОпределитьСклад();
			РежимЗаписи = ?(ДокументОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
			ДокументОбъект.Записать(РежимЗаписи);
		КонецЦикла;
	КонецЦикла;
	ОбновитьТаблицуНераспределенныеЗаказыСервер();
	Элементы.МаршрутныеЛисты.Обновить();
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗаказВМаршрутСервер(Знач СтрокиЗаказов, Знач МаршрутныйЛист)
	Если ЗначениеЗаполнено(МаршрутныйЛист) Тогда
		ДокументОбъект = МаршрутныйЛист.ПолучитьОбъект();
		
		ЭтоВладелецМаршрутногоЛиста = Не ЗначениеЗаполнено(ДокументОбъект.Ответственный)
			Или ДокументОбъект.Ответственный = ТекущийПользователь;
		
		Если Не ДокументОбъект.Проведен
			И Не ЭтоВладелецМаршрутногоЛиста Тогда
			
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(
					НСтр("ru='Право редактирования состава маршрутного листа есть только у автора дакумента (%1)'"),
					ДокументОбъект.Ответственный));
			Возврат;
		КонецЕсли;
		
		Для каждого ИдентификаторСтроки Из СтрокиЗаказов Цикл
			ДанныеЗаказа = НераспределенныеЗаказы.НайтиПоИдентификатору(ИдентификаторСтроки);
			ДокументОбъект.ДобавитьЗаказ(ДанныеЗаказа.Заказ, ДанныеЗаказа.ПунктНазначения);
			
			УдалитьЗаказИзСпискаНераспределенныхЗаказов(ДанныеЗаказа.Заказ);
		КонецЦикла;
		
		РежимЗаписи = ?(ДокументОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
		ДокументОбъект.Записать(РежимЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УбратьЗаказИзМаршрутногоЛистаСервер(Знач ЗаказыКУдалению, Знач МаршрутныйЛист)
	Если ЗначениеЗаполнено(МаршрутныйЛист) Тогда
		ДокументОбъект = МаршрутныйЛист.ПолучитьОбъект();
		Для каждого Заказ Из ЗаказыКУдалению Цикл
			ДокументОбъект.УдалитьЗаказ(Заказ);
		КонецЦикла;
		Если ДокументОбъект.Проведен Тогда
			РежимЗаписи = ?(ДокументОбъект.Заказы.Количество() = 0, 
				РежимЗаписиДокумента.ОтменаПроведения, РежимЗаписиДокумента.Проведение);
		Иначе 
			РежимЗаписи = РежимЗаписиДокумента.Запись;
		КонецЕсли;
		ДокументОбъект.Записать(РежимЗаписи);
		ОбновитьТаблицуНераспределенныеЗаказыСервер();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗаказыВМаршрутСервер(Знач МаршрутныйЛист)
	Если ЗначениеЗаполнено(МаршрутныйЛист) Тогда
		ДокументОбъект = МаршрутныйЛист.ПолучитьОбъект();
		СтрокиЗаказов = НераспределенныеЗаказы.НайтиСтроки(Новый Структура("Пометка", Истина));
		Для каждого ДанныеЗаказа Из СтрокиЗаказов Цикл
			ДокументОбъект.ДобавитьЗаказ(ДанныеЗаказа.Заказ, ДанныеЗаказа.ПунктНазначения);
		КонецЦикла;
		РежимЗаписи = ?(ДокументОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
		ДокументОбъект.Записать(РежимЗаписи);
		ОбновитьТаблицуНераспределенныеЗаказыСервер();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаказИзСпискаНераспределенныхЗаказов(Заказ)
	Отбор = Новый Структура("Заказ", Заказ);
	СтрокиУдалить = НераспределенныеЗаказы.НайтиСтроки(Отбор);
	
	Для Каждого СтрокаУдалить Из СтрокиУдалить Цикл
		НераспределенныеЗаказы.Удалить(СтрокаУдалить);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СоздатьНовыйМаршрутныйЛист(ДанныеЗаполнения)
	МаршрутныйЛист = Документы.битМаршрутныйЛист.СоздатьДокумент();
	МаршрутныйЛист.Заполнить(ДанныеЗаполнения);
	МаршрутныйЛист.Дата = ТекущаяДатаСеанса();
	МаршрутныйЛист.Записать();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьОтмененныеЗаказыНаСервере(Знач МаршрутныеЛисты)
	Обработки.бг_ФормированиеМаршрутныхЛистов.УдалитьОтмененныеЗаказыИзМаршрутныхЛистов(МаршрутныеЛисты);
КонецПроцедуры

#КонецОбласти
