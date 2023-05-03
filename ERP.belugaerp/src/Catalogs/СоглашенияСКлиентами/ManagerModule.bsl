
#Область ПрограммныйИнтерфейс

// Функция - Соглашение по партнеру и организации
//
// Параметры:
//  Партнер		 - СправочникСсылка.Партнеры - партнер соглашения
//  Организация	 - СправочникСсылка.Организации - организация соглашения
// 
// Возвращаемое значение:
//  СправочникСсылка.СоглашенияСКлиентами - отобранное соглашение
//
Функция бг_СоглашениеПоПартнеруИОрганизации(Партнер, Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СоглашенияСКлиентами.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|ГДЕ
		|	НЕ СоглашенияСКлиентами.ПометкаУдаления
		|	И СоглашенияСКлиентами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
		|	И СоглашенияСКлиентами.Партнер = &Партнер
		|	И СоглашенияСКлиентами.Организация = &Организация
		|	И СоглашенияСКлиентами.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи)";	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);	
	РезультатЗапроса = Запрос.Выполнить();

	Соглашение = Неопределено;
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();

		Соглашение = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат Соглашение;

КонецФункции

#КонецОбласти