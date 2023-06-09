#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура бг_ПодготовитьТаблицуВыпускаемойПродукции(Запрос) Экспорт
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭтапПроизводства.Дата КАК Дата,
	|	ЭтапПроизводства.Ссылка КАК ЭтапПроизводства,
	|	ЭтапПроизводства.Организация КАК Организация,
	|	ЭтапПроизводстваВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ЭтапПроизводстваВыходныеИзделия.бг_ПроизводственнаяЛиния КАК ПроизводственнаяЛиния,
	|	ЭтапПроизводстваВыходныеИзделия.ДатаПроизводства КАК ДатаРозлива,
	|	ЭтапПроизводстваВыходныеИзделия.Серия КАК Серия,
	|	СУММА(ЭтапПроизводстваВыходныеИзделия.Количество) КАК Количество
	|ПОМЕСТИТЬ втМаркируемаяПродукция
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ЭтапПроизводстваВыходныеИзделия
	|		ПО (ЭтапПроизводства.Ссылка = &Ссылка)
	|			И ЭтапПроизводства.Ссылка = ЭтапПроизводстваВыходныеИзделия.Ссылка
	|			И (ЭтапПроизводстваВыходныеИзделия.Произведено)
	|ГДЕ
	|	НЕ ЭтапПроизводстваВыходныеИзделия.Отменено
	|	И ЕСТЬNULL(ЭтапПроизводстваВыходныеИзделия.Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|	И НЕ ЕСТЬNULL(ЭтапПроизводстваВыходныеИзделия.Серия.бг_Экспорт, ЛОЖЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЭтапПроизводства.Дата,
	|	ЭтапПроизводства.Ссылка,
	|	ЭтапПроизводстваВыходныеИзделия.Номенклатура,
	|	ЭтапПроизводстваВыходныеИзделия.бг_ПроизводственнаяЛиния,
	|	ЭтапПроизводстваВыходныеИзделия.ДатаПроизводства,
	|	ЭтапПроизводстваВыходныеИзделия.Серия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура";
	
	Результат = Запрос.Выполнить();
КонецПроцедуры

Процедура бг_ПодготовитьДанныеДвиженияМарок(Запрос) Экспорт
	// В рамках одного этапа для каждой выпускаемой продукции (номенклатуры) указывается исключительно одна партия (серия)
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МаркируемаяПродукция.ЭтапПроизводства КАК ЭтапПроизводства,
	|	ДанныеСПроизводственнойЛинии.Ссылка КАК ДанныеСПроизводственнойЛинии,
	|	МаркируемаяПродукция.Номенклатура КАК Номенклатура,
	|	МаркируемаяПродукция.Серия КАК Серия,
	|	ВЫБОР
	|		КОГДА МаркируемаяПродукция.ПроизводственнаяЛиния = ЗНАЧЕНИЕ(Справочник.бг_ПроизводственныеЛинии.ПустаяСсылка)
	|				ИЛИ МаркируемаяПродукция.ПроизводственнаяЛиния = ДанныеСПроизводственнойЛинии.ПроизводственнаяЛиния
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПроизводственнаяЛинияСоответствуетДокументу
	|ПОМЕСТИТЬ втДанныеСПроизводственнойЛинии
	|ИЗ
	|	втМаркируемаяПродукция КАК МаркируемаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.битДанныеСПроизводственнойЛинии КАК ДанныеСПроизводственнойЛинии
	|		ПО МаркируемаяПродукция.ДатаРозлива = ДанныеСПроизводственнойЛинии.ДатаРозлива
	|			И МаркируемаяПродукция.Организация = ДанныеСПроизводственнойЛинии.Организация
	|			И МаркируемаяПродукция.Номенклатура = ДанныеСПроизводственнойЛинии.Номенклатура
	|			И (ДанныеСПроизводственнойЛинии.Статус = ЗНАЧЕНИЕ(Перечисление.бг_СтатусыЗагрузкиДанныхСПроизводственнойЛинии.Загружен))
	|			И (ДанныеСПроизводственнойЛинии.Проведен)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДанныеСПроизводственнойЛинии
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеСПроизводственнойЛинии.ЭтапПроизводства КАК ЭтапПроизводства,
	|	втДанныеСПроизводственнойЛинии.ПроизводственнаяЛинияСоответствуетДокументу КАК ПроизводственнаяЛинияСоответствуетДокументу,
	|	&ПериодДвиженийМарок КАК Период,
	|	втДанныеСПроизводственнойЛинии.Номенклатура КАК Номенклатура,
	|	втДанныеСПроизводственнойЛинии.Серия КАК Серия,
	|	ДвижениеМарок.ГУИДМарки КАК ГУИДМарки,
	|	ДвижениеМарок.КодУпаковки КАК КодУпаковки
	|ПОМЕСТИТЬ втДвижениеМарок
	|ИЗ
	|	втДанныеСПроизводственнойЛинии КАК втДанныеСПроизводственнойЛинии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ДвижениеМарок КАК ДвижениеМарок
	|		ПО втДанныеСПроизводственнойЛинии.ДанныеСПроизводственнойЛинии = ДвижениеМарок.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ втДанныеСПроизводственнойЛинии";
	
	Результат = Запрос.Выполнить();
КонецПроцедуры

Процедура бг_ПодготовитьТаблицуПропущенныхМарок(Запрос) Экспорт
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИдентификаторыМарок.НомерМарки КАК НомерМарки
	|ПОМЕСТИТЬ ДвиженияНомеровМарок
	|ИЗ
	|	втДвижениеМарок КАК втДвижениеМарок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ИдентификаторыМарок КАК ИдентификаторыМарок
	|		ПО втДвижениеМарок.ГУИДМарки = ИдентификаторыМарок.ГУИДМарки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИдентификаторыМарок.НомерМарки
	|ИЗ
	|	РегистрСведений.бг_ДвижениеМарок КАК ДвижениеМарок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ИдентификаторыМарок КАК ИдентификаторыМарок
	|		ПО (ДвижениеМарок.Период = &ПериодДвиженийМарок)
	|			И (ДвижениеМарок.СтатусМарки = &СтатусМаркиПропущена)
	|			И ДвижениеМарок.ГУИДМарки = ИдентификаторыМарок.ГУИДМарки
	|			И (ДвижениеМарок.Регистратор <> &Ссылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерМарки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбеспечениеМатериаламиИРаботами.Серия КАК Серия,
	|	СерииНоменклатуры.бг_ПолныйНачальныйНомерДиапазона КАК НачальныйНомерДиапазона,
	|	СерииНоменклатуры.бг_ПолныйКонечныйНомерДиапазона КАК КонечныйНомерДиапазона
	|ПОМЕСТИТЬ СерииФСМ
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ОбеспечениеМатериаламиИРаботами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|		ПО (ОбеспечениеМатериаламиИРаботами.Ссылка = &Ссылка)
	|			И (ОбеспечениеМатериаламиИРаботами.Номенклатура.ВидНоменклатуры = &ВидНоменклатурыФСМ)
	|			И ОбеспечениеМатериаламиИРаботами.Серия = СерииНоменклатуры.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НачальныйНомерДиапазона,
	|	КонечныйНомерДиапазона
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СерииФСМ.Серия КАК Серия,
	|	СерииФСМ.НачальныйНомерДиапазона КАК НачальныйНомерДиапазона,
	|	СерииФСМ.КонечныйНомерДиапазона КАК КонечныйНомерДиапазона,
	|	ДвиженияНомеровМарок.НомерМарки КАК НомерМарки
	|ПОМЕСТИТЬ ДвижениеНомеровМарокПоДиапазонам
	|ИЗ
	|	СерииФСМ КАК СерииФСМ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДвиженияНомеровМарок КАК ДвиженияНомеровМарок
	|		ПО СерииФСМ.НачальныйНомерДиапазона <= ДвиженияНомеровМарок.НомерМарки
	|			И СерииФСМ.КонечныйНомерДиапазона >= ДвиженияНомеровМарок.НомерМарки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерМарки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияНомеровМарок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СерииФСМ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвижениеНомеровМарокПоДиапазонамТаблица1.Серия КАК Серия,
	|	ДвижениеНомеровМарокПоДиапазонамТаблица1.НачальныйНомерДиапазона КАК НачальныйНомерДиапазона,
	|	ДвижениеНомеровМарокПоДиапазонамТаблица1.КонечныйНомерДиапазона КАК КонечныйНомерДиапазона,
	|	ДвижениеНомеровМарокПоДиапазонамТаблица1.НомерМарки КАК НомерМарки
	|ПОМЕСТИТЬ ПропущенныеМаркиПредварительно
	|ИЗ
	|	ДвижениеНомеровМарокПоДиапазонам КАК ДвижениеНомеровМарокПоДиапазонамТаблица1
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДвижениеНомеровМарокПоДиапазонам КАК ДвижениеНомеровМарокПоДиапазонамТаблица2
	|		ПО ДвижениеНомеровМарокПоДиапазонамТаблица1.Серия = ДвижениеНомеровМарокПоДиапазонамТаблица2.Серия
	|			И (ДвижениеНомеровМарокПоДиапазонамТаблица1.НомерМарки = ДвижениеНомеровМарокПоДиапазонамТаблица2.НомерМарки - 1)
	|ГДЕ
	|	ДвижениеНомеровМарокПоДиапазонамТаблица2.НомерМарки ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Серия,
	|	НомерМарки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПропущенныеМарки.Серия КАК Серия,
	|	ПропущенныеМарки.НачальныйНомерДиапазона КАК НачальныйНомерДиапазона,
	|	ПропущенныеМарки.КонечныйНомерДиапазона КАК КонечныйНомерДиапазона,
	|	ПропущенныеМарки.НомерМарки + 1 КАК НомерМарки,
	|	МИНИМУМ(ДвижениеНомеровМарокПоДиапазонам.НомерМарки) КАК СледующийНомерМарки
	|ПОМЕСТИТЬ ПропущенныеМарки
	|ИЗ
	|	ПропущенныеМаркиПредварительно КАК ПропущенныеМарки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДвижениеНомеровМарокПоДиапазонам КАК ДвижениеНомеровМарокПоДиапазонам
	|		ПО ПропущенныеМарки.Серия = ДвижениеНомеровМарокПоДиапазонам.Серия
	|			И ПропущенныеМарки.НомерМарки < ДвижениеНомеровМарокПоДиапазонам.НомерМарки
	|
	|СГРУППИРОВАТЬ ПО
	|	ПропущенныеМарки.Серия,
	|	ПропущенныеМарки.НачальныйНомерДиапазона,
	|	ПропущенныеМарки.КонечныйНомерДиапазона,
	|	ПропущенныеМарки.НомерМарки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвижениеНомеровМарокПоДиапазонам.Серия КАК Серия,
	|	ДвижениеНомеровМарокПоДиапазонам.НачальныйНомерДиапазона КАК НачальныйНомерДиапазона,
	|	ДвижениеНомеровМарокПоДиапазонам.КонечныйНомерДиапазона КАК КонечныйНомерДиапазона,
	|	МИНИМУМ(ДвижениеНомеровМарокПоДиапазонам.НомерМарки) КАК НачальныйНомерМаркировки,
	|	МАКСИМУМ(ДвижениеНомеровМарокПоДиапазонам.НомерМарки) КАК КонечныйНомерМаркировки
	|ПОМЕСТИТЬ ДиапазоныМаркировкиПредварительно
	|ИЗ
	|	ДвижениеНомеровМарокПоДиапазонам КАК ДвижениеНомеровМарокПоДиапазонам
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвижениеНомеровМарокПоДиапазонам.Серия,
	|	ДвижениеНомеровМарокПоДиапазонам.НачальныйНомерДиапазона,
	|	ДвижениеНомеровМарокПоДиапазонам.КонечныйНомерДиапазона
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Серия,
	|	НачальныйНомерМаркировки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Данные.Серия КАК Серия,
	|	Данные.НачальныйНомерМаркировки КАК НачальныйНомерМаркировки,
	|	Данные.КонечныйНомерМаркировки КАК КонечныйНомерМаркировки,
	|	МАКСИМУМ(Данные.НачалоРулона) КАК НачалоРулона,
	|	МАКСИМУМ(Данные.КонецРулона) КАК КонецРулона
	|ПОМЕСТИТЬ ДиапазоныМаркировки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДиапазоныМаркировкиПредварительно.Серия КАК Серия,
	|		ДиапазоныМаркировкиПредварительно.НачальныйНомерМаркировки КАК НачальныйНомерМаркировки,
	|		ДиапазоныМаркировкиПредварительно.НачальныйНомерДиапазона КАК НачалоРулона,
	|		ДиапазоныМаркировкиПредварительно.КонечныйНомерМаркировки КАК КонечныйНомерМаркировки,
	|		ДиапазоныМаркировкиПредварительно.КонечныйНомерДиапазона КАК КонецРулона
	|	ИЗ
	|		ДиапазоныМаркировкиПредварительно КАК ДиапазоныМаркировкиПредварительно
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДиапазоныМаркировкиПредварительно.Серия,
	|		ДиапазоныМаркировкиПредварительно.НачальныйНомерМаркировки,
	|		ИдентификаторыМарок.НомерМарки + 1,
	|		ДиапазоныМаркировкиПредварительно.КонечныйНомерМаркировки,
	|		0
	|	ИЗ
	|		ДиапазоныМаркировкиПредварительно КАК ДиапазоныМаркировкиПредварительно
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ИдентификаторыМарок КАК ИдентификаторыМарок
	|			ПО ДиапазоныМаркировкиПредварительно.Серия = ИдентификаторыМарок.СерияФСМ
	|				И (ИдентификаторыМарок.НомерМарки < ДиапазоныМаркировкиПредварительно.НачальныйНомерМаркировки)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ДвижениеМарок КАК ДвижениеМарок
	|			ПО (ИдентификаторыМарок.ГУИДМарки = ДвижениеМарок.ГУИДМарки)
	|				И (ДвижениеМарок.Регистратор <> &Ссылка)) КАК Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	Данные.Серия,
	|	Данные.НачальныйНомерМаркировки,
	|	Данные.КонечныйНомерМаркировки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвижениеНомеровМарокПоДиапазонам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПропущенныеМаркиПредварительно
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДиапазоныМаркировкиПредварительно";
	
	Результат = Запрос.Выполнить();
КонецПроцедуры

Процедура бг_СформироватьЗакрывающиеДокументы(Ссылка, Отказ) Экспорт
	Если Не ТипЗнч(Ссылка) = Тип("Массив") Тогда
		МассивРаспоряжений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
	Иначе
		МассивРаспоряжений = Ссылка;
	КонецЕсли;
	
	ДанныеДляФормирования = бг_ПараметрыФормированияДокументов(МассивРаспоряжений);
	
	НачатьТранзакцию();
	Попытка
		бг_ОтменитьПроведениеЗакрывающихДокументов(ДанныеДляФормирования, Отказ);
		
		ДанныеПоСтрокам = бг_ДанныеПоТоварам(МассивРаспоряжений);
		бг_СформироватьФинансовыеДокументы(ДанныеДляФормирования.ОсновныеДанные, ДанныеПоСтрокам, Отказ);
		бг_СформироватьСкладскиеДокументы(ДанныеДляФормирования.ОсновныеДанные, ДанныеПоСтрокам, Отказ);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ШапкаОшибки = ОписаниеОшибки();
		
		ТелоОшибки = "";
		Для каждого СообщениеПользователю Из ПолучитьСообщенияПользователю(Истина) Цикл
			ТелоОшибки = ТелоОшибки + ?(ПустаяСтрока(ТелоОшибки), "", Символы.ПС) + СообщениеПользователю.Текст;
		КонецЦикла;
		
		ТекстОшибки = ШапкаОшибки + Символы.ПС + ТелоОшибки;
		
		ОтменитьТранзакцию();
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
КонецПроцедуры

Процедура бг_ЗаписатьСоответствиеМаркиИСерииФСМ(Ссылка, Отказ, СтатусыМарок = Неопределено) Экспорт
	Если Не ТипЗнч(Ссылка) = Тип("Массив") Тогда
		МассивДокументов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
	Иначе
		МассивДокументов = Ссылка;
	КонецЕсли;
	
	Если СтатусыМарок = Неопределено Тогда
		СтатусыМарок = Новый Массив;
		
		СтатусыДвиженияМарокЭтапПроизводства =
				Перечисления.бг_СтатусыАкцизныхМарок.СтатусыПоОперации(Метаданные.Документы.ЭтапПроизводства2_2.Имя);
		Для Каждого СтатусДвиженияМарок Из СтатусыДвиженияМарокЭтапПроизводства Цикл
			СтатусыМарок.Добавить(СтатусДвиженияМарок.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ВидНоменклатурыФСМ", бг_КонстантыПовтИсп.ЗначениеКонстанты("ФедеральнаяСпецМарка"));
	Запрос.УстановитьПараметр("СтатусыМарок", СтатусыМарок);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОбеспечениеМатериаламиИРаботами.Ссылка КАК ЭтапПроизводства,
	|	ТаблицаОбеспечениеМатериаламиИРаботами.Серия КАК СерияФСМ,
	|	ТаблицаОбеспечениеМатериаламиИРаботами.Серия.бг_ПолныйНачальныйНомерДиапазона КАК ПолныйНачальныйНомерДиапазона,
	|	ТаблицаОбеспечениеМатериаламиИРаботами.Серия.бг_ПолныйКонечныйНомерДиапазона КАК ПолныйКонечныйНомерДиапазона,
	|	ЭтапПроизводства2_2.Организация КАК Организация
	|ПОМЕСТИТЬ СерииФСМ
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ТаблицаОбеспечениеМатериаламиИРаботами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|		ПО ТаблицаОбеспечениеМатериаламиИРаботами.Ссылка = ЭтапПроизводства2_2.Ссылка
	|ГДЕ
	|	ТаблицаОбеспечениеМатериаламиИРаботами.Ссылка В(&МассивДокументов)
	|	И ТаблицаОбеспечениеМатериаламиИРаботами.Серия.ВидНоменклатуры = &ВидНоменклатурыФСМ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПолныйНачальныйНомерДиапазона,
	|	ПолныйКонечныйНомерДиапазона
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДвижениеМарок.Регистратор КАК ЭтапПроизводства,
	|	ДвижениеМарок.ГУИДМарки КАК ГУИДМарки,
	|	ИдентификаторыМарок.НомерМарки КАК НомерМарки,
	|	ИдентификаторыМарок.ИдентификаторМарки КАК ИдентификаторМарки
	|ПОМЕСТИТЬ НомераМарок
	|ИЗ
	|	РегистрСведений.бг_ДвижениеМарок КАК ДвижениеМарок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.бг_ИдентификаторыМарок КАК ИдентификаторыМарок
	|		ПО (ДвижениеМарок.Регистратор В (&МассивДокументов))
	|			И ДвижениеМарок.ГУИДМарки = ИдентификаторыМарок.ГУИДМарки
	|ГДЕ
	|	ДвижениеМарок.СтатусМарки В(&СтатусыМарок)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерМарки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераМарок.ГУИДМарки КАК ГУИДМарки,
	|	НомераМарок.НомерМарки КАК НомерМарки,
	|	НомераМарок.ИдентификаторМарки КАК ИдентификаторМарки,
	|	СерииФСМ.СерияФСМ КАК СерияФСМ,
	|	СерииФСМ.Организация КАК Организация,
	|	СерииФСМ.СерияФСМ.бг_ОрганизацияЕГАИСВладелец КАК ОрганизацияЕГАИС
	|ИЗ
	|	НомераМарок КАК НомераМарок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СерииФСМ КАК СерииФСМ
	|		ПО НомераМарок.ЭтапПроизводства = СерииФСМ.ЭтапПроизводства
	|			И НомераМарок.НомерМарки >= СерииФСМ.ПолныйНачальныйНомерДиапазона
	|			И НомераМарок.НомерМарки <= СерииФСМ.ПолныйКонечныйНомерДиапазона
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бг_ИдентификаторыМарок КАК ИдентификаторыМарок
	|		ПО НомераМарок.ГУИДМарки = ИдентификаторыМарок.ГУИДМарки
	|			И (СерииФСМ.СерияФСМ = ИдентификаторыМарок.СерияФСМ)
	|ГДЕ
	|	ИдентификаторыМарок.СерияФСМ ЕСТЬ NULL";
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.бг_ИдентификаторыМарок.ЗаписатьИдентификаторМарки(
			Выборка.ГУИДМарки,
			Выборка.НомерМарки,
			Выборка.ИдентификаторМарки,
			Выборка.ОрганизацияЕГАИС,
			Выборка.СерияФСМ);
	КонецЦикла;
КонецПроцедуры

&После("ДобавитьКомандыОтчетов")
Процедура бг_ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.бг_СоответствиеРасходаМатериаловВПроизводствеНормативам.ДобавитьКомандуСоответствиеРасходаМатериаловНормативам(КомандыОтчетов);
	
	Отчеты.бг_ДвижениеМарок.ДобавитьКомандуДвижениеМарокПоДокументу(КомандыОтчетов);
	
КонецПроцедуры

// Интерфейс для отложенной обработки этапов производства
//
// Параметры:
//   Объект - ДокументСсылка.ЭтапПроизводства2_2
//   ВариантОбработки - ПеречислениеСсылка.бг_ВариантыОтложеннойОбработкиОбъектов, Неопределено - вариант обработки
//   Отказ - Булево - отказ от обработки
//
Процедура бг_ОтложеннаяОбработкаОбъекта(Объект, ВариантОбработки, Отказ,
	ДополнительныеСведения = Неопределено) Экспорт
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Если ВариантОбработки = Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.ОбработатьАкцизныеМарки Тогда
		бг_ЗаписатьСоответствиеМаркиИСерииФСМ(Объект, Отказ);
	ИначеЕсли ВариантОбработки = Перечисления.бг_ВариантыОтложеннойОбработкиОбъектов.СформироватьДокументы Тогда
		бг_СформироватьЗакрывающиеДокументы(Объект, Отказ);
	Иначе
		// NOP
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&Вместо("ОформитьОтгрузкуТоваров")
Процедура бг_ОформитьОтгрузкуТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ТекстЗапросаДанныхДокумента = 
	"ВЫБРАТЬ
	|	ТабличнаяЧасть.Ссылка                         КАК Ссылка,
	|	Выбор 
	|		Когда ТабличнаяЧасть.Ссылка.НеОтгружатьЧастями Тогда
	|			ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ТабличнаяЧасть.ДатаОтгрузки, ДЕНЬ), ЧАС, ЧАС(ТабличнаяЧасть.Ссылка.бг_ДатаОтгрузкиВремя)), МИНУТА, МИНУТА(ТабличнаяЧасть.Ссылка.бг_ДатаОтгрузкиВремя)), СЕКУНДА, СЕКУНДА(ТабличнаяЧасть.Ссылка.бг_ДатаОтгрузкиВремя))
	|		Иначе ТабличнаяЧасть.ДатаОтгрузки                   
	|	Конец КАК Период,
	|	ТабличнаяЧасть.Ссылка                         КАК Заказ,
	|	ТабличнаяЧасть.Ссылка                         КАК Накладная,
	|	ЛОЖЬ                                          КАК Исправление,
	|	НЕОПРЕДЕЛЕНО                                  КАК ИсправляемыйДокумент,
	|	ТабличнаяЧасть.Подразделение                  КАК Получатель,
	|	ТабличнаяЧасть.Склад                          КАК Склад,
	|	ТабличнаяЧасть.Номенклатура                   КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика                 КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ТабличнаяЧасть.Обособленно
	|			ТОГДА ТабличнаяЧасть.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ                                         КАК Назначение,
	|	ТабличнаяЧасть.Серия                          КАК Серия,
	|	ТабличнаяЧасть.СтатусУказанияСерийОтправитель КАК СтатусУказанияСерий,
	|	ТабличнаяЧасть.Количество                     КАК Количество,	
	|	ЛОЖЬ                                          КАК ОтгрузкаПоЗаказу,
	|	ЛОЖЬ                                          КАК СверхЗаказа
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ТабличнаяЧасть
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Кладовые
	|		ПО Кладовые.Ссылка = ТабличнаяЧасть.Склад
	|		 И Кладовые.ЦеховаяКладовая
	|		 И Кладовые.Подразделение = ТабличнаяЧасть.Подразделение
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка В (&Ссылка)
	|	И ТабличнаяЧасть.Ссылка.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Сформирован),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.КВыполнению),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Начат),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Завершен))
	|	И ТабличнаяЧасть.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногоОборотнаяТара))
	|	И ТабличнаяЧасть.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
	|	И НЕ ТабличнаяЧасть.Ссылка.ПроизводствоНаСтороне
	|	И НЕ Кладовые.Ссылка ЕСТЬ NULL
	|	И НЕ ТабличнаяЧасть.Отменено";
	
	СкладыСервер.ОформитьОтгрузкуТоваров(Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаДанныхДокумента);
	
КонецПроцедуры

Процедура бг_ОтменитьПроведениеЗакрывающихДокументов(ДанныеДляФормирования, Отказ)
	Для Каждого СтрокаДокументы Из ДанныеДляФормирования.СкладскиеДокументы Цикл
		бг_ОтменитьПроведениеДокумента(СтрокаДокументы.СкладскойДокумент, Отказ);
	КонецЦикла;
	
	Для Каждого СтрокаДокументы Из ДанныеДляФормирования.ФинансовыеДокументы Цикл
		бг_ОтменитьПроведениеДокумента(СтрокаДокументы.ФинансовыйДокумент, Отказ);
	КонецЦикла;
КонецПроцедуры

Процедура бг_ОтменитьПроведениеДокумента(СсылкаНаОбъект, Отказ) 
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = СсылкаНаОбъект.ПолучитьОбъект();
	
	Если ДокументОбъект.Проведен Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
КонецПроцедуры

Функция бг_ПараметрыФормированияДокументов(МассивРаспоряжений)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДвижениеПродукцииИМатериалов.Ссылка КАК ФинансовыйДокумент,
	|	ДвижениеПродукцииИМатериалов.Отправитель КАК Отправитель,
	|	ДвижениеПродукцииИМатериалов.Получатель КАК Получатель,
	|	ДвижениеПродукцииИМатериалов.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДвижениеПродукцииИМатериалов.Распоряжение КАК Распоряжение
	|ПОМЕСТИТЬ втВсеФинансовыеДокументы
	|ИЗ
	|	Документ.ДвижениеПродукцииИМатериалов КАК ДвижениеПродукцииИМатериалов
	|ГДЕ
	|	ДвижениеПродукцииИМатериалов.Распоряжение В(&МассивРаспоряжений)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(втВсеФинансовыеДокументы.ФинансовыйДокумент) КАК ФинансовыйДокумент,
	|	втВсеФинансовыеДокументы.Отправитель КАК Отправитель,
	|	втВсеФинансовыеДокументы.Получатель КАК Получатель,
	|	втВсеФинансовыеДокументы.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	втВсеФинансовыеДокументы.Распоряжение КАК Распоряжение
	|ПОМЕСТИТЬ втФинансовыеДокументы
	|ИЗ
	|	втВсеФинансовыеДокументы КАК втВсеФинансовыеДокументы
	|
	|СГРУППИРОВАТЬ ПО
	|	втВсеФинансовыеДокументы.Отправитель,
	|	втВсеФинансовыеДокументы.Получатель,
	|	втВсеФинансовыеДокументы.ХозяйственнаяОперация,
	|	втВсеФинансовыеДокументы.Распоряжение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриходныйОрдерНаТовары.Ссылка КАК СкладскойДокумент,
	|	ПриходныйОрдерНаТовары.Распоряжение КАК Распоряжение
	|ПОМЕСТИТЬ втВсеСкладскиеДокументы
	|ИЗ
	|	Документ.ПриходныйОрдерНаТовары КАК ПриходныйОрдерНаТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втФинансовыеДокументы КАК втФинансовыеДокументы
	|		ПО ПриходныйОрдерНаТовары.Распоряжение = втФинансовыеДокументы.ФинансовыйДокумент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(втВсеСкладскиеДокументы.СкладскойДокумент) КАК СкладскойДокумент,
	|	втВсеСкладскиеДокументы.Распоряжение КАК Распоряжение
	|ПОМЕСТИТЬ втСкладскиеДокументы
	|ИЗ
	|	втВсеСкладскиеДокументы КАК втВсеСкладскиеДокументы
	|
	|СГРУППИРОВАТЬ ПО
	|	втВсеСкладскиеДокументы.Распоряжение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Распоряжение КАК Распоряжение,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Отправитель КАК Отправитель,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Получатель КАК Получатель,
	|	МАКСИМУМ(КОНЕЦПЕРИОДА(РаспоряженияНаПередачуИзПроизводстваОбороты.Период, ДЕНЬ)) КАК Дата,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Операция КАК ХозяйственнаяОперация,
	|	ЭтапПроизводства2_2.Организация КАК Организация,
	|	ЭтапПроизводства2_2.ВидЦены КАК ВидЦены,
	|	ЭтапПроизводства2_2.ВариантПриемкиТоваров КАК ВариантПриемкиТоваров,
	|	ЭтапПроизводства2_2.Валюта КАК Валюта,
	|	ЕСТЬNULL(втФинансовыеДокументы.ФинансовыйДокумент, НЕОПРЕДЕЛЕНО) КАК ФинансовыйДокумент,
	|	ЕСТЬNULL(втФинансовыеДокументы.ФинансовыйДокумент.Номер, """") КАК НомерПервичногоДокумента,
	|	ЕСТЬNULL(втСкладскиеДокументы.СкладскойДокумент, НЕОПРЕДЕЛЕНО) КАК СкладскойДокумент
	|ИЗ
	|	РегистрНакопления.РаспоряженияНаПередачуИзПроизводства.Обороты(, , Регистратор, Распоряжение В (&МассивРаспоряжений)) КАК РаспоряженияНаПередачуИзПроизводстваОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства2_2
	|		ПО РаспоряженияНаПередачуИзПроизводстваОбороты.Распоряжение = ЭтапПроизводства2_2.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ втФинансовыеДокументы КАК втФинансовыеДокументы
	|		ПО РаспоряженияНаПередачуИзПроизводстваОбороты.Распоряжение = втФинансовыеДокументы.Распоряжение
	|			И РаспоряженияНаПередачуИзПроизводстваОбороты.Отправитель = втФинансовыеДокументы.Отправитель
	|			И РаспоряженияНаПередачуИзПроизводстваОбороты.Получатель = втФинансовыеДокументы.Получатель
	|			И РаспоряженияНаПередачуИзПроизводстваОбороты.Операция = втФинансовыеДокументы.ХозяйственнаяОперация
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСкладскиеДокументы КАК втСкладскиеДокументы
	|		ПО (втФинансовыеДокументы.ФинансовыйДокумент = втСкладскиеДокументы.Распоряжение)
	|ГДЕ
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Регистратор В(&МассивРаспоряжений)
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Распоряжение,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Отправитель,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Получатель,
	|	РаспоряженияНаПередачуИзПроизводстваОбороты.Операция,
	|	ЭтапПроизводства2_2.Организация,
	|	ЭтапПроизводства2_2.ВидЦены,
	|	ЭтапПроизводства2_2.ВариантПриемкиТоваров,
	|	ЭтапПроизводства2_2.Валюта,
	|	ЕСТЬNULL(втФинансовыеДокументы.ФинансовыйДокумент, НЕОПРЕДЕЛЕНО),
	|	ЕСТЬNULL(втФинансовыеДокументы.ФинансовыйДокумент.Номер, """"),
	|	ЕСТЬNULL(втСкладскиеДокументы.СкладскойДокумент, НЕОПРЕДЕЛЕНО)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втВсеФинансовыеДокументы.ФинансовыйДокумент КАК ФинансовыйДокумент
	|ИЗ
	|	втВсеФинансовыеДокументы КАК втВсеФинансовыеДокументы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втВсеСкладскиеДокументы.СкладскойДокумент КАК СкладскойДокумент
	|ИЗ
	|	втВсеСкладскиеДокументы КАК втВсеСкладскиеДокументы";
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений);
	РезультатЗапросаПакет = Запрос.ВыполнитьПакет();
	ИндексЗапросаСкладскиеДокументы = РезультатЗапросаПакет.Количество() - 1;
	ИндексЗапросаФинансовыеДокументы = ИндексЗапросаСкладскиеДокументы - 1;
	ИндексЗапросаОсновныеДанные = ИндексЗапросаФинансовыеДокументы - 1;
	Результат = Новый Структура;
	Результат.Вставить("СкладскиеДокументы", РезультатЗапросаПакет[ИндексЗапросаСкладскиеДокументы].Выгрузить());
	Результат.Вставить("ФинансовыеДокументы", РезультатЗапросаПакет[ИндексЗапросаФинансовыеДокументы].Выгрузить());
	Результат.Вставить("ОсновныеДанные", РезультатЗапросаПакет[ИндексЗапросаОсновныеДанные].Выгрузить());
	Возврат Результат;
КонецФункции

Функция бг_ДанныеПоТоварам(МассивРаспоряжений)
	Результат = Неопределено;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Распоряжение КАК Распоряжение,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Отправитель КАК Отправитель,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Получатель КАК Получатель,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Номенклатура КАК Номенклатура,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Серия КАК Серия,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.Операция КАК ХозяйственнаяОперация,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.КоличествоОстаток КАК Количество,
	               |	РаспоряженияНаПередачуИзПроизводстваОстатки.КодСтроки КАК КодСтроки
	               |ИЗ
	               |	РегистрНакопления.РаспоряженияНаПередачуИзПроизводства.Остатки(, Распоряжение В (&МассивРаспоряжений)) КАК РаспоряженияНаПередачуИзПроизводстваОстатки";
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
КонецФункции

Процедура бг_СформироватьФинансовыеДокументы(ДанныеДляФормирования, СтрокиТоварыВсехРаспоряжений, Отказ)
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаДанные Из ДанныеДляФормирования Цикл
		Если ЗначениеЗаполнено(СтрокаДанные.ФинансовыйДокумент) Тогда
			ФинансовыйДокументОбъект = СтрокаДанные.ФинансовыйДокумент.ПолучитьОбъект();
		Иначе
			ФинансовыйДокументОбъект = Документы.ДвижениеПродукцииИМатериалов.СоздатьДокумент();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ФинансовыйДокументОбъект, СтрокаДанные, 
		"Организация, Дата, Валюта, ВидЦены, ВариантПриемкиТоваров, 
		|Отправитель, Получатель, Распоряжение, ХозяйственнаяОперация");
		ФинансовыйДокументОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
		ФинансовыйДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		ФинансовыйДокументОбъект.ПоРаспоряжениям = Истина;
		ФинансовыйДокументОбъект.Статус = Перечисления.СтатусыДвиженияПродукцииИМатериалов.Принято;
		ФинансовыйДокументОбъект.ПометкаУдаления = Ложь;
		ФинансовыйДокументОбъект.Товары.Очистить();
		СтруктураПоиска = Новый Структура("Распоряжение, Отправитель, Получатель, ХозяйственнаяОперация");
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаДанные);
		ТаблицаСтроки = СтрокиТоварыВсехРаспоряжений.НайтиСтроки(СтруктураПоиска);
		Для Каждого СтрокаРаспоряжение Из ТаблицаСтроки Цикл
			НоваяСтрокаДокумента = ФинансовыйДокументОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДокумента, СтрокаРаспоряжение);
			НоваяСтрокаДокумента.КоличествоУпаковок = НоваяСтрокаДокумента.Количество;
			НоваяСтрокаДокумента.СтатусУказанияСерий = ?(ЗначениеЗаполнено(НоваяСтрокаДокумента.Серия), 14, 0);
			НоваяСтрокаДокумента.СтатусУказанияСерийОтправитель = НоваяСтрокаДокумента.СтатусУказанияСерий;
			НоваяСтрокаДокумента.СтатусУказанияСерийПолучатель = НоваяСтрокаДокумента.СтатусУказанияСерий;
		КонецЦикла;
		Если ФинансовыйДокументОбъект.Товары.Количество() > 0 Тогда
			ФинансовыйДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ФинансовыйДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		СтрокаДанные.ФинансовыйДокумент = ФинансовыйДокументОбъект.Ссылка;
		СтрокаДанные.НомерПервичногоДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ФинансовыйДокументОбъект.Номер);
	КонецЦикла;
КонецПроцедуры

Процедура бг_СформироватьСкладскиеДокументы(ДанныеДляФормирования, СтрокиТоварыВсехРаспоряжений, Отказ)
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Для каждого СтрокаДокумент Из ДанныеДляФормирования Цикл
		Если СкладыСервер.ИспользоватьОрдернуюСхемуПриПоступлении(СтрокаДокумент.Получатель, СтрокаДокумент.Дата) 
			И ЗначениеЗаполнено(СтрокаДокумент.ФинансовыйДокумент) Тогда
			ДокументЭтап = СтрокаДокумент.Распоряжение;
			Если ЗначениеЗаполнено(СтрокаДокумент.СкладскойДокумент) Тогда
				ПриходныйОрдерОбъект = СтрокаДокумент.СкладскойДокумент.ПолучитьОбъект();
			Иначе
				ПриходныйОрдерОбъект = Документы.ПриходныйОрдерНаТовары.СоздатьДокумент();
			КонецЕсли;
			ПриходныйОрдерОбъект.Дата = КонецДня(СтрокаДокумент.Дата);
			ПриходныйОрдерОбъект.ПометкаУдаления = Ложь;
			ПриходныйОрдерОбъект.ДатаВходящегоДокумента = СтрокаДокумент.Дата;
			ПриходныйОрдерОбъект.НомерВходящегоДокумента = СтрокаДокумент.НомерПервичногоДокумента;
			ПриходныйОрдерОбъект.Ответственный = Пользователи.ТекущийПользователь();
			ПриходныйОрдерОбъект.Отправитель = СтрокаДокумент.Отправитель;
			ПриходныйОрдерОбъект.Распоряжение = СтрокаДокумент.ФинансовыйДокумент;
			ПриходныйОрдерОбъект.Склад = СтрокаДокумент.Получатель;
			ПриходныйОрдерОбъект.СкладскаяОперация = СкладыКлиентСервер.СкладскаяОперацияПриемкиПоХозяйственнойОперации(
														СтрокаДокумент.ХозяйственнаяОперация);
			ПриходныйОрдерОбъект.Статус = Перечисления.СтатусыПриходныхОрдеров.Принят;
			ПриходныйОрдерОбъект.ХозяйственнаяОперация = СтрокаДокумент.ХозяйственнаяОперация;
			
			ПриходныйОрдерОбъект.Товары.Очистить();
			СтруктураПоиска = Новый Структура("Распоряжение, Отправитель, Получатель, ХозяйственнаяОперация");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаДокумент);
			ТаблицаСтроки = СтрокиТоварыВсехРаспоряжений.НайтиСтроки(СтруктураПоиска);
			Для Каждого СтрокаРаспоряжение Из ТаблицаСтроки Цикл
				НоваяСтрокаДокумента = ПриходныйОрдерОбъект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДокумента, СтрокаРаспоряжение);
				НоваяСтрокаДокумента.КоличествоУпаковок = НоваяСтрокаДокумента.Количество;
				НоваяСтрокаДокумента.СтатусУказанияСерий = ?(ЗначениеЗаполнено(НоваяСтрокаДокумента.Серия), 14, 0);
			КонецЦикла;
			
			ПриходныйОрдерОбъект.ВсегоМест = УпаковочныеЛистыСервер.КоличествоМестВТЧ(ПриходныйОрдерОбъект.Товары);
			
			Если ПриходныйОрдерОбъект.Товары.Количество() > 0 Тогда
				ПриходныйОрдерОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				ПриходныйОрдерОбъект.ОбменДанными.Загрузка = Истина;
				ПриходныйОрдерОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
			СтрокаДокумент.СкладскойДокумент = ПриходныйОрдерОбъект.Ссылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти 

#КонецЕсли
