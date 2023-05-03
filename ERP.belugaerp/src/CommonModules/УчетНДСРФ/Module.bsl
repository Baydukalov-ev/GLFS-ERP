
&ИзменениеИКонтроль("АктуализироватьСчетаФактурыВыданныеПриПроведении")
Процедура бг_АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОснований.Ссылка КАК Ссылка,
	|	ТаблицаОснований.Ссылка.Контрагент КАК Контрагент
	|ИЗ
	|	Документ.СчетФактураВыданный.ДокументыОснования КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.ДокументОснование = &ДокументПродажи
	|	И ТаблицаОснований.Ссылка.Проведен
	|";
	Запрос.УстановитьПараметр("ДокументПродажи", ПараметрыРегистрации.Ссылка);

	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Документ.СчетФактураВыданный");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();

		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПроверкаДокументов_Отключить", Истина);
		ДокументОбъект.ДополнительныеСвойства.Вставить("АктуализацияДвижений", Истина);
#Вставка
		ДокументОбъект.ДатаВыставления = ПараметрыРегистрации.Дата;
		Если ПараметрыРегистрации.Свойство("АктуализироватьДатуВыставленияСФ") Тогда
			ДокументОбъект.ДополнительныеСвойства.Вставить("АктуализироватьДатуВыставленияСФ", Истина);
		КонецЕсли;
#КонецВставки

		Если Выборка.Контрагент <> ПараметрыРегистрации.Контрагент Тогда
			ДокументОбъект.ЗаполнитьПараметрыСчетаФактурыПоОснованию();
		КонецЕсли;

		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);

	ОснованияСчетаФактуры = Новый Массив;
	ОснованияСчетаФактуры.Добавить(ПараметрыРегистрации.Ссылка);
	РегистрыСведений.ТребуетсяОформлениеСчетаФактуры.ОбновитьСостояние(ПараметрыРегистрации.Ссылка, ОснованияСчетаФактуры);
	//++ НЕ УТ
	РегистрыСведений.ТаможенныеДекларацииЭкспортКРегистрации.ОбновитьСостояние(ОснованияСчетаФактуры);
	//-- НЕ УТ

КонецПроцедуры

&ИзменениеИКонтроль("ЗаполнитьСчетФактураВыданный")
Функция бг_ЗаполнитьСчетФактураВыданный(СчетФактура, ПараметрыРегистрации)

	Результат = Новый Структура;
	Результат.Вставить("Проведен", Истина);
	Результат.Вставить("СообщениеОбОшибке", "");

	СчетФактураОбъект = СчетФактура;
	Если ТипЗнч(СчетФактура) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
		СчетФактураОбъект = СчетФактура.ПолучитьОбъект();
	КонецЕсли;

	СчетФактураОбъект.ДокументыОснования.Очистить();

	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокументОснование", ПараметрыРегистрации.Ссылка);
	ДанныеЗаполнения.Вставить("Организация", ПараметрыРегистрации.Организация);
	ДанныеЗаполнения.Вставить("Контрагент", ПараметрыРегистрации.Контрагент);
	ДанныеЗаполнения.Вставить("Исправление", ПараметрыРегистрации.ИсправлениеОшибок);
	ДанныеЗаполнения.Вставить("Корректировочный", ПараметрыРегистрации.КорректировкаПоСогласованиюСторон);
#Вставка
	ДанныеЗаполнения.Вставить("ДатаВыставления", ПараметрыРегистрации.Дата);
#КонецВставки

	СчетФактураОбъект.Заполнить(ДанныеЗаполнения);
	Попытка
		Результат.Проведен = Истина;
#Вставка
		Если ПараметрыРегистрации.Свойство("бг_ЗаписатьБезПроведения")
				И ПараметрыРегистрации.бг_ЗаписатьБезПроведения Тогда
			Результат.Проведен = Ложь;
			СчетФактураОбъект.Записать(РежимЗаписиДокумента.Запись);
		Иначе
#КонецВставки
		СчетФактураОбъект.Записать(РежимЗаписиДокумента.Проведение);
#Вставка
		КонецЕсли;
#КонецВставки
	Исключение
		Результат.Проведен = Ложь;
		Результат.СообщениеОбОшибке = ОписаниеОшибки();
		СчетФактураОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;

	Возврат Результат;

КонецФункции