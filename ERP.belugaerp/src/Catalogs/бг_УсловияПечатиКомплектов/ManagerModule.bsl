#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПодходящиеУсловияОтбораПоОбъектам(ТипОбъекта, Объекты) Экспорт
	
	ТипОбъектаБезВида = СтрЗаменить(ТипОбъекта, "Документ.", "");
	
	ОбъектыСУсловиями = Новый ТаблицаЗначений;
	ОбъектыСУсловиями.Колонки.Добавить("Объект",
		Новый ОписаниеТипов("ДокументСсылка." + ТипОбъектаБезВида));
	ОбъектыСУсловиями.Колонки.Добавить("УсловиеОтбора",
		Новый ОписаниеТипов("СправочникСсылка.бг_УсловияПечатиКомплектов"));
	ОбъектыСУсловиями.Колонки.Добавить("Приоритет",
		Метаданные.Справочники.бг_УсловияПечатиКомплектов.Реквизиты.Приоритет.Тип);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Т.Ссылка КАК УсловиеОтбора,
	|	Т.Приоритет КАК Приоритет,
	|	Т.НастройкиКомпоновкиДанных КАК Настройки
	|ИЗ
	|	Справочник.бг_УсловияПечатиКомплектов КАК Т
	|ГДЕ
	|	Т.ТипОбъекта = &ТипОбъекта
	|	И НЕ Т.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.Приоритет";
	
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъектаБезВида);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СхемаКомпоновкиДанных = ПолучитьМакет(ТипОбъектаБезВида);
	КомпоновкаДанныхСервер.УстановитьПараметрСКД(СхемаКомпоновкиДанных, "МассивОбъектов", Объекты);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	Пока Выборка.Следующий() Цикл
	
		НастройкиКомпоновки = Выборка.Настройки.Получить();
		Если НастройкиКомпоновки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки,,,
			Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ТаблицаДокументов = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		Для Каждого СтрокаДокумента Из ТаблицаДокументов Цикл
			
			НовыйОбъект = ОбъектыСУсловиями.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйОбъект, Выборка);
			НовыйОбъект.Объект = СтрокаДокумента.Ссылка;

		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОбъектыСУсловиями;
	
КонецФункции

#КонецОбласти

#КонецЕсли