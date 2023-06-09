
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает коллекцию колонок с номерами колонок в файле загрузки.
// Параметры:
//	Фактор - СправочникСсылка.Контрагенты
//	ВидОперации - ПеречислениеСсылка.бг_ВидыОперацийФакторинга
// Возвращаемое значение:
//	Структура - имя колонки и номер колонки в файле.
//
Функция ОписаниеЗагружаемыхКолонок(Фактор, ВидОперации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Настройки.ПерваяСтрока КАК ПерваяСтрока,
	|	Настройки.НомерДокумента КАК НомерДокумента,
	|	Настройки.ДатаДокумента КАК ДатаДокумента,
	|	Настройки.Сумма КАК Сумма,
	|	Настройки.СуммаФинансирования КАК СуммаФинансирования,
	|	Настройки.КомиссияПоФинансированиюНДС КАК КомиссияПоФинансированиюНДС,
	|	Настройки.КомиссияПоФинансированиюБезНДС КАК КомиссияПоФинансированиюБезНДС,
	|	Настройки.КомиссияПоФинансированиюВсего КАК КомиссияПоФинансированиюВсего,
	|	Настройки.КомиссияПоАдминистративномуУправлениюНДС КАК КомиссияПоАдминистративномуУправлениюНДС,
	|	Настройки.КомиссияПоАдминистративномуУправлениюБезНДС КАК КомиссияПоАдминистративномуУправлениюБезНДС,
	|	Настройки.КомиссияПоАдминистративномуУправлениюВсего КАК КомиссияПоАдминистративномуУправлениюВсего,
	|	Настройки.СборЗаНакладнуюНДС КАК СборЗаНакладнуюНДС,
	|	Настройки.СборЗаНакладнуюБезНДС КАК СборЗаНакладнуюБезНДС,
	|	Настройки.СборЗаНакладнуюВсего КАК СборЗаНакладнуюВсего,
	|	Настройки.Остаток КАК Остаток,
	|	Настройки.ДатаПогашенияФинансирования КАК ДатаПогашенияФинансирования,
	|	Настройки.Контрагент КАК Контрагент
	|ИЗ
	|	РегистрСведений.бг_НастройкиЗагрузкиФайловФакторинга КАК Настройки
	|ГДЕ
	|	Настройки.Фактор = &Фактор
	|	И Настройки.ВидОперации = &ВидОперации";
	
	Запрос.УстановитьПараметр("Фактор", Фактор);
	Запрос.УстановитьПараметр("ВидОперации", ВидОперации);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	ИменаКолонокДокумента = ИменаКолонокДокумента();
	ОписаниеКолонок = Новый Структура;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			
			ИмяКолонкиВНастройках = Колонка.Имя;
			ИмяКолонкиВДокументе = ИменаКолонокДокумента.Получить(ИмяКолонкиВНастройках);
			Если ИмяКолонкиВДокументе = Неопределено Тогда
				ИмяКолонкиВДокументе = ИмяКолонкиВНастройках;
			КонецЕсли;
			
			ДобавитьОписаниеКолонки(ОписаниеКолонок, ИмяКолонкиВДокументе, Выборка[ИмяКолонкиВНастройках]);
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОписаниеКолонок;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИменаКолонокДокумента()
	
	Имена = Новый Соответствие;
	Имена.Вставить("КомиссияПоФинансированиюНДС", "КомиссияНДС1");
	Имена.Вставить("КомиссияПоФинансированиюБезНДС", "КомиссияБезНДС1");
	Имена.Вставить("КомиссияПоФинансированиюВсего", "Комиссия1");
	Имена.Вставить("КомиссияПоАдминистративномуУправлениюНДС", "КомиссияНДС2");
	Имена.Вставить("КомиссияПоАдминистративномуУправлениюБезНДС", "КомиссияБезНДС2");
	Имена.Вставить("КомиссияПоАдминистративномуУправлениюВсего", "Комиссия2");
	Имена.Вставить("СборЗаНакладнуюНДС", "КомиссияНДС3");
	Имена.Вставить("СборЗаНакладнуюБезНДС", "КомиссияБезНДС3");
	Имена.Вставить("СборЗаНакладнуюВсего", "Комиссия3");
	
	Возврат Имена;
	
КонецФункции

Процедура ДобавитьОписаниеКолонки(ОписаниеКолонок, ИмяКолонки, НомерКолонки)
	
	Если Не ЗначениеЗаполнено(НомерКолонки) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКолонкиВТаблицеДанных = Новый Структура;
	Если ТипЗнч(НомерКолонки) = Тип("Число") Тогда
		ОписаниеКолонкиВТаблицеДанных.Вставить(ИмяКолонки, НомерКолонки);
	Иначе
		ДобавитьОписаниеКолонкиИзСтроки(ОписаниеКолонкиВТаблицеДанных, ИмяКолонки, НомерКолонки);
	КонецЕсли;
	
	Если ОписаниеКолонкиВТаблицеДанных.Количество() Тогда
		ОписаниеКолонок.Вставить(ИмяКолонки, ОписаниеКолонкиВТаблицеДанных);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОписаниеКолонкиИзСтроки(ОписаниеКолонкиВТаблицеДанных, ИмяКолонки, НомерКолонки)
	
	Колонки = СтрРазделить(НомерКолонки, ",", Ложь);
	Если Колонки.Количество() > 1 Тогда
		Для Каждого Колонка Из Колонки Цикл
			
			НомерКолонкиЧислом = Число(Колонка);
			Если ЗначениеЗаполнено(НомерКолонкиЧислом) Тогда
				ОписаниеКолонкиВТаблицеДанных.Вставить(
					СтрШаблон("%1%2", ИмяКолонки, СокрЛП(Колонка)), НомерКолонкиЧислом);
			КонецЕсли;
			
		КонецЦикла;
	Иначе
		
		НомерКолонкиЧислом = Число(НомерКолонки);
		Если ЗначениеЗаполнено(НомерКолонкиЧислом) Тогда
			ОписаниеКолонкиВТаблицеДанных.Вставить(ИмяКолонки, НомерКолонкиЧислом);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
