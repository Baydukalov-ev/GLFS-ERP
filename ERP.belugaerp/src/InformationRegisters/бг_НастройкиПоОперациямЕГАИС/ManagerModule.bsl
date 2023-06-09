
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОперацииСОнлайнВыгрузкой() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Т.Операция КАК Операция
		|ИЗ
		|	РегистрСведений.бг_НастройкиПоОперациямЕГАИС КАК Т
		|ГДЕ
		|	Т.Приоритет = 0";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Операция");
	
КонецФункции

Функция НедоступныеОперацииПоИнтервалуРегистрации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОперацииПоОрганизациям = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОписаниеПакета.ВладелецФайла КАК ОрганизацияЕГАИС,
	|	Настройки.ИнтервалРегистрации КАК Интервал,
	|	Настройки.Операция КАК Операция
	|ИЗ
	|	РегистрСведений.бг_НастройкиПоОперациямЕГАИС КАК Настройки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ОписаниеПакета
	|		ПО Настройки.Операция = ОписаниеПакета.Операция
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьПередачиДанныхЕГАИС КАК Очередь
	|		ПО (Очередь.Сообщение = ОписаниеПакета.Ссылка)
	|ГДЕ
	|	Настройки.ИнтервалРегистрации > 0
	|	И (ОписаниеПакета.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийЕГАИС.КПередаче)
	|			И НЕ Очередь.Сообщение ЕСТЬ NULL
	|		ИЛИ ОписаниеПакета.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийЕГАИС.ПереданоВУТМ))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОписаниеПакета.ВладелецФайла,
	|	Настройки.Операция,
	|	Настройки.ИнтервалРегистрации
	|
	|ИМЕЮЩИЕ
	|	РАЗНОСТЬДАТ(
	|		МАКСИМУМ(ВЫБОР
	|			КОГДА Очередь.Сообщение ЕСТЬ NULL
	|				ТОГДА ОписаниеПакета.ДатаСоздания
	|			ИНАЧЕ &ТекущаяДата
	|		КОНЕЦ), &ТекущаяДата, МИНУТА) < Настройки.ИнтервалРегистрации
	|
	|ИТОГИ ПО
	|	ОписаниеПакета.ВладелецФайла";

	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Результат = Запрос.Выполнить();
	ВыборкаПоОрганизациям = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Операции = Новый ТаблицаЗначений;
	Операции.Колонки.Добавить("Операция");
	Операции.Колонки.Добавить("Интервал");
	
	Пока ВыборкаПоОрганизациям.Следующий() Цикл
		
		Операции.Очистить();
		ВыборкаДетальная = ВыборкаПоОрганизациям.Выбрать();
		Пока ВыборкаДетальная.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Операции.Добавить(), ВыборкаДетальная);
		КонецЦикла;
		
		ОперацииПоОрганизациям.Вставить(ВыборкаПоОрганизациям.ОрганизацияЕГАИС, Операции);
		
	КонецЦикла;
	
	Возврат ОперацииПоОрганизациям;
	
КонецФункции

// Недоступные операции для отправки в УТМ, если с момента отправки не прошло достаточно времени.
// Параметры:
//	ОрганизацииЕГАИС - Массив - организации ЕГАИС.
// Возвращаемое значение:
//	Соответствие - операции по которым не прошло достаточно времени по организациям.
//
Функция НедоступныеОперацииПоИнтервалуОтправки(ОрганизацииЕГАИС) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОперацииПоОрганизациям = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОписаниеПакета.ВладелецФайла КАК ОрганизацияЕГАИС,
	|	Настройки.ИнтервалОтправки КАК Интервал,
	|	Настройки.Операция КАК Операция
	|ИЗ
	|	РегистрСведений.бг_НастройкиПоОперациямЕГАИС КАК Настройки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ОписаниеПакета
	|		ПО Настройки.Операция = ОписаниеПакета.Операция
	|ГДЕ
	|	ОписаниеПакета.ВладелецФайла В (&ОрганизацииЕГАИС)
	|	И Настройки.ИнтервалОтправки > 0
	|	И ОписаниеПакета.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийЕГАИС.ПереданоВУТМ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОписаниеПакета.ВладелецФайла,
	|	Настройки.Операция,
	|	Настройки.ИнтервалОтправки
	|
	|ИМЕЮЩИЕ
	|	РАЗНОСТЬДАТ(
	|		МАКСИМУМ(ОписаниеПакета.ДатаСоздания), &ТекущаяДата, МИНУТА) < Настройки.ИнтервалОтправки
	|
	|ИТОГИ ПО
	|	ОписаниеПакета.ВладелецФайла";

	Запрос.УстановитьПараметр("ОрганизацииЕГАИС", ОрганизацииЕГАИС);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	
	Результат = Запрос.Выполнить();
	ВыборкаПоОрганизациям = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Операции = Новый ТаблицаЗначений;
	Операции.Колонки.Добавить("Операция");
	Операции.Колонки.Добавить("Интервал");
	
	Пока ВыборкаПоОрганизациям.Следующий() Цикл
		
		Операции.Очистить();
		ВыборкаДетальная = ВыборкаПоОрганизациям.Выбрать();
		Пока ВыборкаДетальная.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Операции.Добавить(), ВыборкаДетальная);
		КонецЦикла;
		
		ОперацииПоОрганизациям.Вставить(ВыборкаПоОрганизациям.ОрганизацияЕГАИС, Операции);
		
	КонецЦикла;
	
	Возврат ОперацииПоОрганизациям;
	
КонецФункции

#КонецОбласти

#КонецЕсли