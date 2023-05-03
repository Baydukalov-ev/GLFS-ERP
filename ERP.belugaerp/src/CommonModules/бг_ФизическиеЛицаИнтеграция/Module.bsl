#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСоставВыгружаемыхОбъектов(РеквизитыИСвойства, ФорматСообщения, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ОставитьРеквизиты(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		ВыгружаемыеРеквизиты());
		
	ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства);
		
КонецПроцедуры 

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ЗагружаемыйОбъект.Наименование = СтруктураОбъекта.Наименование;
	ЗагружаемыйОбъект.НаименованиеСлужебное = СтруктураОбъекта.Наименование;
	Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
		ЗагружаемыйОбъект.УстановитьНовыйКод();
	КонецЕсли;
	
	ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(СтруктураОбъекта.Наименование);
	
	Если ЗначениеЗаполнено(ФИО.Имя)
		И ЗначениеЗаполнено(ФИО.Отчество) Тогда
		Инициалы = СтрШаблон("%1. %2.", Лев(ФИО.Имя, 1), Лев(ФИО.Отчество, 1));
	ИначеЕсли ЗначениеЗаполнено(ФИО.Имя) Тогда
		Инициалы = Лев(ФИО.Имя, 1) + ".";
	ИначеЕсли ЗначениеЗаполнено(ФИО.Отчество) Тогда
		Инициалы = Лев(ФИО.Отчество, 1) + ".";
	Иначе
		Инициалы = "";
	КонецЕсли;
	
	ФИО.Вставить("Инициалы", Инициалы);
	
	Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
		ЗаписатьФИОВРегистр(ЗагружаемыйОбъект.ПолучитьСсылкуНового(), 
			ФИО,
			Истина,
			ЗагружаемыйОбъект.НаименованиеСлужебное);
	Иначе
		ЗаписатьФИОВРегистр(ЗагружаемыйОбъект.Ссылка, 
			ФИО,
			Ложь,
			ЗагружаемыйОбъект.НаименованиеСлужебное);
	КонецЕсли;
		
	ДатаУдостоверения = Дата(1, 1, 1);
	Если ЗначениеЗаполнено(СтруктураОбъекта.синДатаУдостоверения) Тогда
		ДатаУдостоверения = СтруктураОбъекта.синДатаУдостоверения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураОбъекта.алкНомерУдостоверения) Тогда
		Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
			ЗаписатьДанныеВодительскогоУдостоверения(ЗагружаемыйОбъект.ПолучитьСсылкуНового(), 
				ДатаУдостоверения,
				СтруктураОбъекта.алкНомерУдостоверения,
				Истина);
		Иначе
			ЗаписатьДанныеВодительскогоУдостоверения(ЗагружаемыйОбъект.Ссылка, 
				ДатаУдостоверения,
				СтруктураОбъекта.алкНомерУдостоверения,
				Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьФИОВРегистр(ФизическоеЛицо, ФИО, ЭтоНовый, НаименованиеСлужебное)
	
	МенеджерЗаписи = РегистрыСведений.ФИОФизическихЛиц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ФизическоеЛицо = ФизическоеЛицо;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран()
		И МенеджерЗаписи.Фамилия = ФИО.Фамилия
		И МенеджерЗаписи.Имя = ФИО.Имя
		И МенеджерЗаписи.Отчество = ФИО.Отчество Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ФИО, "Фамилия, Имя, Отчество, Инициалы");
	МенеджерЗаписи.ФизическоеЛицо = ФизическоеЛицо;
	МенеджерЗаписи.ФИОСлужебные = НаименованиеСлужебное;
	
	ДатаПоУмолчанию = Дата(1980, 1, 1);
	Если ЭтоНовый Тогда
		МенеджерЗаписи.Период = ДатаПоУмолчанию;
	Иначе
		МенеджерЗаписи.Период = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Процедура ЗаписатьДанныеВодительскогоУдостоверения(ФизическоеЛицо, ДатаВыдачи, Номер, ЭтоНовый)
	
	ВидДокументаВодительскоеУдостоверение = 
		ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ВодительскоеУдостоверение");
		
	МенеджерЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Физлицо = ФизическоеЛицо;
	МенеджерЗаписи.ВидДокумента = ВидДокументаВодительскоеУдостоверение;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран()
		И МенеджерЗаписи.ДатаВыдачи = ДатаВыдачи
		И МенеджерЗаписи.Номер = Номер Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи.Физлицо = ФизическоеЛицо;
	МенеджерЗаписи.ВидДокумента = ВидДокументаВодительскоеУдостоверение;
	МенеджерЗаписи.ДатаВыдачи = ДатаВыдачи;
	МенеджерЗаписи.Номер = Номер;
	
	ДатаПоУмолчанию = Дата(1980, 1, 1);
	Если ЭтоНовый Тогда
		МенеджерЗаписи.Период = ДатаПоУмолчанию;
	Иначе
		МенеджерЗаписи.Период = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения) Экспорт
	
	Перем адаптер_ОбработчикиСобытийСтандартный;
	адаптер_ОбработчикиСобытийСтандартный = ОбщегоНазначения.ОбщийМодуль("адаптер_ОбработчикиСобытийСтандартный");
	
	ДанныеВыгружаемогоОбъекта = адаптер_ОбработчикиСобытийСтандартный.ПолучитьДанныеВыгружаемогоОбъекта(Объект, ДанныеСообщения);
	
	Если ДанныеВыгружаемогоОбъекта.Реквизиты.Количество() > 0  Тогда
		РеквизитыОбъекта = ДанныеВыгружаемогоОбъекта.Реквизиты[0]; 
		
		ЗаполнитьДанныеВодительскогоУдостоверения(Объект, РеквизитыОбъекта);
		
	КонецЕсли;
	
	Возврат ДанныеВыгружаемогоОбъекта;

КонецФункции

Функция НайтиСсылкуПоЗагружаемымДанным(СтруктураОбъекта) Экспорт
	Перем адаптер_РаботаСДаннымиИБ;
	адаптер_РаботаСДаннымиИБ = ОбщегоНазначения.ОбщийМодуль("адаптер_РаботаСДаннымиИБ");
	
	ФизЛицо = адаптер_РаботаСДаннымиИБ.НайтиСсылкуПоЗагружаемымДанным(СтруктураОбъекта);
	
	Если ОбщегоНазначения.СсылкаСуществует(ФизЛицо) Тогда
		Возврат ФизЛицо;
	КонецЕсли;
	
	Если СтруктураОбъекта.Свойство("бг_КодБК")
		И ЗначениеЗаполнено(СтруктураОбъекта.бг_КодБК) Тогда 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ФизическиеЛица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.бг_КодБК = &Значение";
		
		Запрос.УстановитьПараметр("Значение", СтруктураОбъекта.бг_КодБК); 
		
		Результат = Запрос.Выполнить();
		Выборка   = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ФизЛицо;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыгружаемыеРеквизиты()

	ВыгружаемыеРеквизиты = Новый Массив;
	
	// Реквизиты шапки
	ВыгружаемыеРеквизиты.Добавить("бг_Руководитель");	
	ВыгружаемыеРеквизиты.Добавить("ДатаРождения");
	ВыгружаемыеРеквизиты.Добавить("Имя");
	ВыгружаемыеРеквизиты.Добавить("ИНН");
	ВыгружаемыеРеквизиты.Добавить("Отчество");
	ВыгружаемыеРеквизиты.Добавить("Пол");
	ВыгружаемыеРеквизиты.Добавить("ПометкаУдаления");
	ВыгружаемыеРеквизиты.Добавить("СтраховойНомерПФР");	
	ВыгружаемыеРеквизиты.Добавить("Фамилия");
	ВыгружаемыеРеквизиты.Добавить("ФИО");	
	ВыгружаемыеРеквизиты = СтрСоединить(ВыгружаемыеРеквизиты, ",");
	
	Возврат ВыгружаемыеРеквизиты;

КонецФункции

Процедура ДобавитьСвязанныеРеквизитыКВыгрузке(РеквизитыИСвойства)

	Перем адаптер_НастройкиОбмена;
	адаптер_НастройкиОбмена = ОбщегоНазначения.ОбщийМодуль("адаптер_НастройкиОбмена");
	
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"НомерВодительскогоУдостоверения",
		ОбщегоНазначения.ОписаниеТипаСтрока(20));
	   
	адаптер_НастройкиОбмена.ДобавитьРеквизит(
		РеквизитыИСвойства,
		РеквизитыИСвойства.МетаданныеОбъекта,
		, // ИмяРеквизита
		"ДатаВодительскогоУдостоверения",
		Новый ОписаниеТипов("Дата"));
		
КонецПроцедуры

Процедура ЗаполнитьДанныеВодительскогоУдостоверения(Объект, РеквизитыОбъекта)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыФизическихЛицСрезПоследних.Номер КАК Номер,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи КАК ДатаВыдачи,
	|	ДокументыФизическихЛицСрезПоследних.Серия КАК Серия
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|			,
	|			Физлицо = &Физлицо
	|				И ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВодительскоеУдостоверение)) КАК ДокументыФизическихЛицСрезПоследних";
	
	Запрос.УстановитьПараметр("Физлицо", Объект);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		РеквизитыОбъекта.Вставить("НомерВодительскогоУдостоверения", СтрШаблон("%1%2", Выборка.Серия, Выборка.Номер));
		РеквизитыОбъекта.Вставить("ДатаВодительскогоУдостоверения" , Выборка.ДатаВыдачи);
		
	КонецЕсли;
	
КонецПроцедуры
	
#Конецобласти //СлужебныеПроцедурыИФункции

