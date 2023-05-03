#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "бг_НарядЗадание") Тогда
		СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"бг_НарядЗадание",
			НСтр("ru = 'Наряд-задание'"),
			ПечатнаяФормаНарядЗадание(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(
		ПараметрыВывода.ПараметрыОтправки,
		МассивОбъектов,
		КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьЦелоеКоличествоУпаковок(ДанныеПоТоварам) Экспорт

	ДанныеПоТоварам.Колонки.Добавить("КоличествоПаллетРасчетное", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ДанныеПоТоварам.Колонки.Добавить("КоличествоКоробокРасчетное", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ДанныеПоТоварам.Колонки.Добавить("КоличествоБутылокРасчетное", ОбщегоНазначения.ОписаниеТипаЧисло(10));
	
	Для каждого ДанныеПоТовару Из ДанныеПоТоварам Цикл
		
		Если ДанныеПоТовару.БутылокВПаллете = 0 Или ДанныеПоТовару.БутылокВКоробке = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеПоТовару.КоличествоПаллетРасчетное = Цел(ДанныеПоТовару.КоличествоБутылок / ДанныеПоТовару.БутылокВПаллете);
		БутылокВЦелыхПаллетах = ДанныеПоТовару.КоличествоПаллетРасчетное * ДанныеПоТовару.БутылокВПаллете;
		БутылокБезЦелыхПаллет = ДанныеПоТовару.КоличествоБутылок - БутылокВЦелыхПаллетах;
		ДанныеПоТовару.КоличествоКоробокРасчетное = Цел(БутылокБезЦелыхПаллет / ДанныеПоТовару.БутылокВКоробке);
		БутылокВЦелыхКоробках = ДанныеПоТовару.КоличествоКоробокРасчетное * ДанныеПоТовару.БутылокВКоробке;
		ДанныеПоТовару.КоличествоБутылокРасчетное = БутылокБезЦелыхПаллет - БутылокВЦелыхКоробках;	
	КонецЦикла;
	
КонецПроцедуры

Функция ИтогиПоТоварам(ДанныеПоТоварам) Экспорт
	
	ПоляИтогов = "Вес, КоличествоКоробок, КоличествоБутылок, КоличествоПаллетРасчетное,
	| КоличествоКоробокРасчетное, КоличествоБутылокРасчетное";
	
	ДанныеИтоговПоТоварам = ДанныеПоТоварам.Скопировать();
	ДанныеИтоговПоТоварам.Свернуть("Документ", ПоляИтогов);
	
	Возврат ДанныеИтоговПоТоварам;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатнаяФормаНарядЗадание(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_БГ_НАРЯД_ЗАДАНИЕ";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.бг_ДанныеДляПечатнойФормыНарядЗадание(
			ПараметрыПечати,
			СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументНарядЗадание(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументНарядЗадание(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)

	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.бг_ПечатьНарядЗаданий.ПФ_MXL_НарядЗадание");

	ЭтоПервыйДокумент = Истина;
	
	Для каждого ДанныеШапкиДокумента Из ДанныеДляПечати.ДанныеПоШапке Цикл
	
		Если ЭтоПервыйДокумент Тогда
			ЭтоПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка         = Макет.ПолучитьОбласть("Шапка");
		ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
		ОбластьПодвал        = Макет.ПолучитьОбласть("Подвал");
		
		// Шапка
		ОбластьШапка.Параметры.Заполнить(ДанныеШапкиДокумента);
		ОбластьШапка.Параметры.ДатаРаспоряжения = Формат(ДанныеШапкиДокумента.ДатаРаспоряжения, "ДФ=dd.MM.yyyy");
		ОбластьШапка.Параметры.ДатаОтгрузки = Формат(ДанныеШапкиДокумента.ДатаОтгрузки, "ДФ=dd.MM.yyyy");
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			Макет,
			ОбластьШапка,
			ДанныеШапкиДокумента.Документ);
				
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		// Таблица и подвал
		ПараметрыПоискаДокумента = Новый Структура("Документ", ДанныеШапкиДокумента.Документ);
		ДанныеТоваровДокумента = ДанныеДляПечати.ДанныеПоТоварам.НайтиСтроки(ПараметрыПоискаДокумента);
		СтрокиИтоговПоТоварамДокумента = ДанныеДляПечати.ДанныеИтоговПоТоварам.НайтиСтроки(ПараметрыПоискаДокумента);
		
		Если ДанныеТоваровДокумента.Количество() > 0 Тогда
			
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			
			НомерСтроки = 1;
			
			Для каждого ДанныеТовара Из ДанныеТоваровДокумента Цикл
				
				ПараметрыСтроки = ОбластьСтрокаТаблицы.Параметры;
				ПараметрыСтроки.Заполнить(ДанныеТовара);
				ПараметрыСтроки.НомерСтроки = НомерСтроки;
				ПараметрыСтроки.Вес = Формат(ДанныеТовара.Вес, "ЧГ=0");
				ПараметрыСтроки.КоличествоКоробок = Формат(ДанныеТовара.КоличествоКоробок, "ЧГ=0");
				ПараметрыСтроки.КоличествоБутылок = Формат(ДанныеТовара.КоличествоБутылок, "ЧГ=0");
				ПараметрыСтроки.КоличествоПаллетРасчетное = Формат(ДанныеТовара.КоличествоПаллетРасчетное, "ЧГ=0");
				ПараметрыСтроки.КоличествоКоробокРасчетное = Формат(ДанныеТовара.КоличествоКоробокРасчетное, "ЧГ=0");
				ПараметрыСтроки.КоличествоБутылокРасчетное = Формат(ДанныеТовара.КоличествоБутылокРасчетное, "ЧГ=0");
				
				Если Не ТабличныйДокумент.ПроверитьВывод(ОбластьСтрокаТаблицы) Тогда
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
				НомерСтроки = НомерСтроки + 1
			КонецЦикла;
			
			ИтогиПоТоварамДокумента = СтрокиИтоговПоТоварамДокумента[0];
			
			ПараметрыПодвала = ОбластьПодвалТаблицы.Параметры;
			ПараметрыПодвала.ВесИтог = Формат(ИтогиПоТоварамДокумента.Вес, "ЧГ=0");
			ПараметрыПодвала.КоличествоКоробокИтог = Формат(ИтогиПоТоварамДокумента.КоличествоКоробок, "ЧГ=0");
			ПараметрыПодвала.КоличествоБутылокИтог = Формат(ИтогиПоТоварамДокумента.КоличествоБутылок, "ЧГ=0");
			ПараметрыПодвала.КоличествоПаллетРасчетноеИтог = Формат(ИтогиПоТоварамДокумента.КоличествоПаллетРасчетное, "ЧГ=0");
			ПараметрыПодвала.КоличествоКоробокРасчетноеИтог = Формат(ИтогиПоТоварамДокумента.КоличествоКоробокРасчетное, "ЧГ=0");
			ПараметрыПодвала.КоличествоБутылокРасчетноеИтог = Формат(ИтогиПоТоварамДокумента.КоличествоБутылокРасчетное, "ЧГ=0");
			
			ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			ДанныеШапкиДокумента.Документ);
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
