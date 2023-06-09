
#Область ПереопределяемыеМетоды

Процедура Подписаться(Подписки) Экспорт
	Подписки.ЗаполнитьВыгружаемыеОбъекты = Истина;
	Подписки.ЗаполнитьСоставВыгружаемыхОбъектов = Истина;
	Подписки.СформироватьТелоСообщения = Истина;
	Подписки.ПолучитьДанныеВыгружаемогоОбъекта = Истина;
КонецПроцедуры

// Заполняет объекты в настройках выгрузки объектов для переданных параметров подключения
//
// Параметры:
//	ПараметрыПодключения	- Неопределено - необходимо заполнить настройки для всех активных (!) подключений
//							- Массив ссылок на элементы справочника настроек подключения, для которых требуется
//								заполнить настройки выгрузки объектов
//	НастройкиВыгрузки		- ТаблицаЗначений - таблица настроек выгрузки объектов, каждая строка описывает
//								выгрузку объекта в заданном формате для заданной ссылки на параметры подключения
//								см. также адаптер_НастройкиОбмена.ПолучитьНастройкиВыгрузки()
//								и адаптер_НастройкиОбмена.ИнициализироватьТаблицуНастроекВыгрузки()
//
Процедура ЗаполнитьВыгружаемыеОбъекты(ПараметрыПодключения, НастройкиВыгрузки, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	ПодключениеDWH = бг_КонстантыПовтИсп.ЗначениеКонстанты("НастройкаПодключенияDWH");
	Если НЕ ЗначениеЗаполнено(ПодключениеDWH) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыПодключения)
		И ПараметрыПодключения.Найти(ПодключениеDWH) = Неопределено Тогда
		
		Возврат;
	КонецЕсли;
	
	ФорматСообщения    = ПредопределенноеЗначение("Перечисление.адаптер_ФорматыСообщений.адаптерJSON");
	ВыгружаемыеОбъекты = ВыгружаемыеОбъекты();
	
	Для каждого ВыгружаемыйОбъект из ВыгружаемыеОбъекты Цикл
		адаптер_НастройкиОбмена.ДобавитьНастройку(НастройкиВыгрузки, ВыгружаемыйОбъект, ПодключениеDWH, ФорматСообщения);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет таблицы выгружаемых реквизитов объектов в настройках выгрузки объектов
//
// Параметры:
//	РеквизитыИСвойства		- Структура - структура описания реквизитов и свойств выгружаемого объекта,
//								см. также адаптер_РаботаСМетаданными.РеквизитыИСвойстваОбъектаМетаданны()
//								и адаптер_РаботаСМетаданными.РеквизитыИСвойстваОбъектаМетаданныххСУчетомНастроек()
//	ФорматСообщения			- ПеречислениеСсылка.адаптер_ФорматыСообщений - формат сообщения, для которого необходимы настройки выгрузки
//	СтандартнаяОбработка	- Булево - признак необходимости дальнейшей обработки события в цепочке подписок
//
Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	Если ФорматСообщения <> ПредопределенноеЗначение("Перечисление.адаптер_ФорматыСообщений.адаптерJSON") Тогда
		Возврат;
	КонецЕсли;
	
	// таблица ключей не используется
	адаптер_НастройкиОбмена.УдалитьРеквизит(РеквизитыИСвойства, Неопределено, "ТаблицаКлючей");
	
	// если объект содержит реквизит с именем Идентификатор, его нужно переименовать, поскольку имя Идентификатор занято ссылкой
	ОписаниеРеквизита = РеквизитыИСвойства.Реквизиты.Найти("Идентификатор", "ИмяСвойстваXDTO");
	Если ОписаниеРеквизита <> Неопределено Тогда
		ОписаниеРеквизита.ИмяСвойстваXDTO = "РеквизитИдентификатор";
	КонецЕсли;
	
	// платформа не поддерживает выгрузку хранилища значения как base64Binary в JSON
	ОтборРеквизитов = Новый Структура("ТипСтрокой", "base64Binary");
	ОписанияРеквизитов = РеквизитыИСвойства.Реквизиты.НайтиСтроки(ОтборРеквизитов);
	Для каждого ОписаниеРеквизита из ОписанияРеквизитов Цикл
		адаптер_НастройкиОбмена.УдалитьРеквизит(РеквизитыИСвойства, РеквизитыИСвойства.МетаданныеОбъекта, ОписаниеРеквизита.ИмяРеквизита);
	КонецЦикла;
	
	УдалитьНеПоддерживаемыеРеквизитыТабличныхЧастей(РеквизитыИСвойства);

	// Типовая ТЧ "Дополнительные реквизиты" не используется, так как реквизит "Значение" этой ТЧ 
	// имеет составной тип Характеристика.ДополнительныеРеквизитыИСведения, 
	// который включает в себя и примитивные и ссылочные типы, что вызывает ошибку при
	// формировании тела сообщения.
	адаптер_НастройкиОбмена.УдалитьРеквизит(РеквизитыИСвойства, Неопределено, "ДополнительныеРеквизиты");

КонецПроцедуры

// Формирует и возвращает тело сообщения
//
// Параметры:
//	ДанныеСообщения		- Структура - стуктура данных сообщения
//
Функция СформироватьТелоСообщения(ДанныеСообщения) Экспорт
	
	Перем адаптер_ОбменДаннымиJSON;
	адаптер_ОбменДаннымиJSON = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбменДаннымиJSON");
	
	Если ДанныеСообщения.ФорматСообщения = ПредопределенноеЗначение("Перечисление.адаптер_ФорматыСообщений.адаптерJSON") Тогда
		Возврат адаптер_ОбменДаннымиJSON.СформироватьТелоСообщения(ДанныеСообщения);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");

	Если ДанныеСообщения.ФорматСообщения <> ПредопределенноеЗначение("Перечисление.адаптер_ФорматыСообщений.адаптерJSON") Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	ОбрабатываемыеМетаданные = Новый Массив;
	
	// Регистры сведений
	ОбрабатываемыеМетаданные.Добавить(Метаданные.РегистрыСведений.бг_ТоварыОрганизацийКВыгрузкеВХранилище);
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	Если ДанныеСообщения.Свойство("МетаданныеОбъекта") И МетаданныеОбъекта <> ДанныеСообщения.МетаданныеОбъекта Тогда
		МетаданныеОбъекта = ДанныеСообщения.МетаданныеОбъекта;
	КонецЕсли;

	Если ОбрабатываемыеМетаданные.Найти(МетаданныеОбъекта) <> Неопределено Тогда
		Модуль = ОбщийМодульПоМетаданнымОбъекта(МетаданныеОбъекта, Объект);
		Возврат Модуль.ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает массив выгружаемых объектов метаданных
//
// Параметры:
//	отсутствуют
//
Функция ВыгружаемыеОбъекты() Экспорт
	
	ОбъектыМетаданных = Новый Массив;
	
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_ВидыПеревозки);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_Группы_СУМ);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_ЕК_СКЮ_СкюМТ);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_ЕК_СУМ);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_ДоговорыВладенияТС);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_КлассыГрузоподъемностиТС);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.бг_ТипыКузова);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.битКаналыПродаж);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.битПунктыНазначения);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.битТерриторииПунктовНазначения);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Валюты); 
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ВидыНоменклатуры);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ВидыЦен);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ДоговорыАренды);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ДоговорыКонтрагентов);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ДоговорыКредитовИДепозитов);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ЕГАИСПрисоединенныеФайлы);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.КлассификаторОрганизацийЕГАИС);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Контрагенты);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Номенклатура);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.НоменклатураКонтрагентов);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Организации);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Партнеры);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Пользователи);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ПричиныОтменыЗаказовКлиентов);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.РабочиеЦентры);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.РесурсныеСпецификации);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.СегментыПартнеров);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.СерииНоменклатуры);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.Склады);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.СтавкиНДС);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ТоварныеКатегории);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ТранспортныеСредства);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.УпаковкиЕдиницыИзмерения);
	ОбъектыМетаданных.Добавить(Метаданные.Справочники.ФизическиеЛица);
	
	ОбъектыМетаданных.Добавить(Метаданные.Документы.АвансовыйОтчет);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.битЗаявкаКлиента);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.битМаршрутныйЛист);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.битОтражениеФактаПоРасходномуОрдеру);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.битРаспределениеТранспортныхРасходов);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ВзаимозачетЗадолженности);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ВозвратТоваровОтКлиента); 
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ВозвратТоваровПоставщику);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ЗаказКлиента);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ЗаказНаПроизводство2_2);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ЗаказПоставщику);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.КорректировкаЗадолженности);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.КорректировкаРеализации); 
	ОбъектыМетаданных.Добавить(Метаданные.Документы.КорректировкаПриобретения);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ОтчетКомитенту);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПервичныйДокумент);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПересчетТоваров);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПеремещениеТоваров);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПриобретениеТоваровУслуг);
        ОбъектыМетаданных.Добавить(Метаданные.Документы.ПриобретениеУслугПрочихАктивов);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.РасходныйОрдерНаТовары);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.РеализацияТоваровУслуг);  
	ОбъектыМетаданных.Добавить(Метаданные.Документы.РеализацияУслугПрочихАктивов);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ТранспортнаяНакладнаяЕГАИС);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ТТНВходящаяЕГАИС);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ТТНИсходящаяЕГАИС);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.УстановкаЦенНоменклатуры);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ЭтапПроизводства2_2);
	
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.бг_НачальныеТоварыЗаказовКлиентов);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.бг_РасстояниеДоПунктовРазгрузки);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.бг_СогласованиеЗаказовКлиентов);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.бг_ТоварыОрганизацийКВыгрузкеВХранилище);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.бг_ТранспортнаяИнформация);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыСведений.СтатусыДокументовЕГАИС);
	
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыНакопления.бг_ПредполагаемоеРаспределениеЗатрат);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыНакопления.бг_РаспределениеЗатрат);
	ОбъектыМетаданных.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам);
	
	Возврат ОбъектыМетаданных;
	
КонецФункции

Функция ОбщийМодульПоМетаданнымОбъекта(МетаданныеОбъекта, Объект)

	Если Метаданные.РегистрыСведений.Содержит(МетаданныеОбъекта) Тогда
		Модуль = бг_ОбщегоНазначенияСервер.ОбщийМодульИнтеграции(Объект.ИмяРегистра, Истина);
	Иначе
		Модуль = бг_ОбщегоНазначенияСервер.ОбщийМодульИнтеграции(МетаданныеОбъекта.Имя, Ложь);	
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

// Удаляет реквизиты с типом хранилище значения, 
// так как платформа не поддерживает выгрузку хранилища значения как base64Binary в JSON.
//
Процедура УдалитьНеПоддерживаемыеРеквизитыТабличныхЧастей(РеквизитыИСвойства)
	
	Если Не РеквизитыИСвойства.Свойство("ТабличныеЧасти") Тогда
		Возврат;
	КонецЕсли;	
	
	ТабличныеЧастиУдалить = Новый Массив;
	Для каждого ТабличнаяЧасть из РеквизитыИСвойства.ТабличныеЧасти Цикл		
		РеквизитыТабличнойЧасти = ТабличнаяЧасть.Значение;
		
		РеквизитыУдалить = Новый Массив;
		Для каждого РеквизитТЧ Из РеквизитыТабличнойЧасти Цикл
			Если СтрСравнить(РеквизитТЧ.ТипСтрокой, "base64Binary") = 0 Тогда
				РеквизитыУдалить.Добавить(РеквизитТЧ);
			КонецЕсли;	
		КонецЦикла;
		
		Для каждого РеквизитТЧ Из РеквизитыУдалить Цикл
			РеквизитыТабличнойЧасти.Удалить(РеквизитТЧ);
		КонецЦикла;
			
		Если РеквизитыТабличнойЧасти.Количество() = 0 Тогда
			ТабличныеЧастиУдалить.Добавить(ТабличнаяЧасть.Ключ);
		КонецЕсли;	
	КонецЦикла;

	Для каждого ИмяТЧ Из ТабличныеЧастиУдалить Цикл
		РеквизитыИСвойства.ТабличныеЧасти.Удалить(ИмяТЧ);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
