#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт

	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.УстановитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ВыгружаемыеРеквизиты());
		
	ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства);	
	ДобавитьКлючевыеРеквизиты(РеквизитыИСвойства);
		
КонецПроцедуры

Процедура ЗаполнитьТекстыЗапросовУсловиями(ТекстЗапроса, ТекстЗапросаТаблицаКлючей, ПараметрыЗапроса, НастройкаВыгрузки, Объект, СтандартнаяОбработка) Экспорт
	
	ТекстЗапросаТаблицаКлючей = "";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВыгружаемыйОбъект.ПериодОкончания КАК ДатаОкончания",
		"ВЫБОР
		|	  КОГДА ВыгружаемыйОбъект.ПериодОкончания = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДАТАВРЕМЯ(3999, 1, 1)
		|		ИНАЧЕ ВыгружаемыйОбъект.ПериодОкончания
		|	КОНЕЦ КАК ДатаОкончания");

	ПараметрыЗапроса.Вставить("ТипЛицензии", Перечисления.бг_ТипыЛицензийПоставщиковАлкогольнойПродукции.Оптовая);
	
КонецПроцедуры

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	  
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ПараметрыВыполненияЗапросов = адаптер_РаботаСДаннымиИБ.ПолучитьПараметрыВыполненияЗапросов(Объект, ДанныеСообщения);

	ПроверятьДополнительныеУсловия = Ложь;
	Если Не ДанныеСообщения.ДополнительныеСвойстваОбъекта.Свойство(
		"адаптер_ПроверятьДополнительныеУсловияПриПолученииДанныхВыгружаемогоОбъекта", ПроверятьДополнительныеУсловия) Тогда
    	ПроверятьДополнительныеУсловия = Ложь;
	КонецЕсли;
	
	РезультатЗапроса = адаптер_РаботаСДаннымиИБ.ПолучитьРезультатЗапроса(ПараметрыВыполненияЗапросов.ТекстыЗапросов.ТекстЗапроса,
		ПараметрыВыполненияЗапросов.ПараметрыЗапроса,
		ПараметрыВыполненияЗапросов.ТаблицаОтбора,
		ПроверятьДополнительныеУсловия);
		
	Реквизиты = адаптер_РаботаСДаннымиИБ.РезультатЗапросаВСтруктуруРеквизитов(РезультатЗапроса, ПараметрыВыполненияЗапросов.ТаблицаКлючей, ДанныеСообщения);
	РеквизитыСообщения = Новый Массив;

	Если Реквизиты.Количество() > 0 Тогда
		РеквизитыОбъекта = Реквизиты[0];
		
		Крепость = 0;
		Если Не РеквизитыОбъекта.Свойство("Крепость", Крепость) Тогда
			Крепость = 0;	
		КонецЕсли; 
		
		ЕмкостьТары = 0;
		Если Не РеквизитыОбъекта.Свойство("ЕмкостьТары", ЕмкостьТары) Тогда
			ЕмкостьТары = 0;
		КонецЕсли; 
		
		ВидАлкогольнойПродукции = Неопределено;
		РеквизитыОбъекта.Свойство("ВидАлкогольнойПродукции", ВидАлкогольнойПродукции); 
		
		СкюМТ = СкюМТ(РеквизитыОбъекта.ДатаНачала, ВидАлкогольнойПродукции, РеквизитыОбъекта.Цена, Крепость, ЕмкостьТары);
		
		Если РеквизитыОбъекта.Свойство("ВидАлкогольнойПродукции") Тогда
			РеквизитыОбъекта.Удалить("ВидАлкогольнойПродукции");
		КонецЕсли; 
		
		Если РеквизитыОбъекта.Свойство("Крепость") Тогда
			РеквизитыОбъекта.Удалить("Крепость");
		КонецЕсли; 
		
		Если РеквизитыОбъекта.Свойство("ЕмкостьТары") Тогда
			РеквизитыОбъекта.Удалить("ЕмкостьТары");
		КонецЕсли; 
		
		Для каждого ЭлементСкюМТ Из СкюМТ Цикл
			ДанныеЗаполнения = ОбщегоНазначения.СкопироватьРекурсивно(РеквизитыОбъекта);				
			ДанныеЗаполнения.Вставить("Цена", ЭлементСкюМТ.Цена);
			ДанныеЗаполнения.Вставить("ДанныеСкюМТ", ЭлементСкюМТ.СКЮ);
			РеквизитыСообщения.Добавить(ДанныеЗаполнения);
		КонецЦикла; 
		
	КонецЕсли; 
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ПолноеИмя", ПараметрыВыполненияЗапросов.ПолноеИмя);
	СтруктураРезультат.Вставить("Реквизиты", РеквизитыСообщения);
	СтруктураРезультат.Вставить("Отбор", Новый Массив);
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	ВыгружаемыеРеквизиты = Новый Массив;
	
	ВыгружаемыеРеквизиты.Добавить("ВидАлкогольнойПродукции");
	ВыгружаемыеРеквизиты.Добавить("Цена");
	ВыгружаемыеРеквизиты.Добавить("Крепость");
			
	Возврат ВыгружаемыеРеквизиты;
	
КонецФункции

Процедура ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		"ЕмкостьТары",
		,
		ОбщегоНазначения.ОписаниеТипаЧисло(10,3));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		"Период",
		"ДатаНачала",
		Новый ОписаниеТипов("Дата"));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		"ПериодОкончания",
		"ДатаОкончания",
		Новый ОписаниеТипов("Дата"));
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		,
		"ДанныеСкюМТ.СкюМТ",
		Новый ОписаниеТипов("СправочникСсылка.бг_ЕК_СКЮ_СкюМТ"));
				
КонецПроцедуры

Процедура ДобавитьКлючевыеРеквизиты(РеквизитыИСвойства)
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		Метаданные.Справочники.бг_ЕК_СКЮ_СкюМТ,
		"Код",
		,
		ОбщегоНазначения.ОписаниеТипаСтрока(15));
		
КонецПроцедуры

Функция СкюМТ(Период, ВидНоменклатуры, Цена, Крепость, ЕмкостьТары)
	
	СКЮ = Новый Массив;
	
	Если ЕмкостьТары = 0 Тогда
		ЦенаЗаПолЛитра = Цена;
	Иначе
		ЦенаЗаПолЛитра = Цена / (ЕмкостьТары / 0.5);
	КонецЕсли; 
	
	ВидАлкогольнойПродукцииДляКонтроляМРЦПрочихЛВИ = бг_КонстантыПовтИсп.ЗначениеКонстанты("ВидАлкогольнойПродукцииДляКонтроляМРЦПрочихЛВИ");
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		
		ВидАлкогольнойПродукции = Справочники.ВидыАлкогольнойПродукции.ПолучитьСсылку(
			Новый УникальныйИдентификатор(ВидНоменклатуры.Идентификатор));
		
	Иначе
		
		ВидАлкогольнойПродукции = Справочники.ВидыАлкогольнойПродукции.ПустаяСсылка();
		
	КонецЕсли; 
	
	Если ВидАлкогольнойПродукции <> ВидАлкогольнойПродукцииДляКонтроляМРЦПрочихЛВИ Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Номенклатура.ТоварнаяКатегория.бг_СкюМТ КАК СКЮ_МТ,
		|	Номенклатура.ТоварнаяКатегория.бг_СкюМТ.Код КАК Код,
		|	Выразить(ВЫБОР
		|		КОГДА &ЕмкостьТары = 0
		|			ТОГДА &Цена * 2 * Номенклатура.ОбъемДАЛ * 10
		|		ИНАЧЕ &Цена / &ЕмкостьТары * Номенклатура.ОбъемДАЛ * 10
		|	КОНЕЦ КАК Число(15,2)) КАК Цена
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.ВидАлкогольнойПродукции = &ВидАлкогольнойПродукции
		|	И (Номенклатура.Крепость > &Крепость 
		|		И Номенклатура.Крепость <= &Крепость + 1
		|			ИЛИ &Крепость = 0)
		|	И НЕ Номенклатура.ТоварнаяКатегория.бг_СкюМТ ЕСТЬ NULL
		|ИТОГИ ПО
		|	Цена";
		
		Запрос.УстановитьПараметр("ВидАлкогольнойПродукции", ВидАлкогольнойПродукции);
		Запрос.УстановитьПараметр("Крепость", Крепость);
		Запрос.УстановитьПараметр("ЕмкостьТары", ЕмкостьТары);
		Запрос.УстановитьПараметр("Цена", ЦенаЗаПолЛитра);
		
		РезультатЗапроса = Запрос.Выполнить();
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	бг_МинимальныеЦеныАлкогольнойПродукцииСрезПоследних.ВидАлкогольнойПродукции
		|ПОМЕСТИТЬ ВТ_ИсключаемыеВидыАлкогольнойПродукции
		|ИЗ
		|	РегистрСведений.бг_МинимальныеЦеныАлкогольнойПродукции.СрезПоследних(&Период, ТипЛицензии = ЗНАЧЕНИЕ(Перечисление.бг_ТипыЛицензийПоставщиковАлкогольнойПродукции.Оптовая)) КАК бг_МинимальныеЦеныАлкогольнойПродукцииСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Номенклатура.ТоварнаяКатегория.бг_СкюМТ КАК СКЮ_МТ,
		|	Номенклатура.ТоварнаяКатегория.бг_СкюМТ.Код КАК Код,
		|	Выразить(ВЫБОР
		|		КОГДА &ЕмкостьТары = 0
		|			ТОГДА &Цена * 2 * Номенклатура.ОбъемДАЛ * 10
		|		ИНАЧЕ &Цена / &ЕмкостьТары * Номенклатура.ОбъемДАЛ * 10
		|	КОНЕЦ КАК Число(15,2)) КАК Цена
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	НЕ Номенклатура.ВидАлкогольнойПродукции В
		|				(ВЫБРАТЬ
		|					Т.ВидАлкогольнойПродукции
		|				ИЗ
		|					ВТ_ИсключаемыеВидыАлкогольнойПродукции КАК Т)
		|	И (Номенклатура.Крепость > &Крепость 
		|		И Номенклатура.Крепость <= &Крепость + 1
		|			ИЛИ &Крепость = 0)
		|	И НЕ Номенклатура.ТоварнаяКатегория.бг_СкюМТ ЕСТЬ NULL
		|ИТОГИ ПО
		|	Цена";
		
		Запрос.УстановитьПараметр("ВидАлкогольнойПродукции", ВидАлкогольнойПродукции);
		Запрос.УстановитьПараметр("Крепость", Крепость);
		Запрос.УстановитьПараметр("ЕмкостьТары", ЕмкостьТары);
		Запрос.УстановитьПараметр("Цена", ЦенаЗаПолЛитра);
		Запрос.УстановитьПараметр("Период", Период);

		РезультатЗапроса = Запрос.Выполнить();
		
	КонецЕсли;
	
	ВыборкаПоЦене = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Цена");
	Пока ВыборкаПоЦене.Следующий() Цикл
		ДанныеПоЦене = Новый Структура("Цена", ВыборкаПоЦене.Цена);		
		СоставСКЮ = Новый Массив;
		Выборка = ВыборкаПоЦене.Выбрать();
		Пока Выборка.Следующий() Цикл
			СоставСКЮ.Добавить(
			Новый Структура("СкюМТ",
				Новый Структура(
					"Идентификатор, Код",
					Строка(Выборка.СКЮ_МТ.УникальныйИдентификатор()),
					Выборка.Код)));	
		КонецЦикла; 
		ДанныеПоЦене.Вставить("СКЮ", СоставСКЮ);
		СКЮ.Добавить(ДанныеПоЦене);
	КонецЦикла; 
	
	Возврат СКЮ;
	
КонецФункции 
 
#КонецОбласти