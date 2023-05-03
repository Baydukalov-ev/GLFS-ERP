#Область ПрограммныйИнтерфейс

Процедура ПерезаполнитьОбеспечениеМатериалами(ЭтапПроизводства) Экспорт
	ОчиститьКорректировкиРасходаМатериалов(ЭтапПроизводства);
	
	ПотребностьСогласноСпецификации = ПотребностьСогласноСпецификации(ЭтапПроизводства);
	
	ПерезаполнитьОбеспечениеМатериалов(ЭтапПроизводства, ПотребностьСогласноСпецификации);
	
	ОтменитьСтрокиОбеспеченияСПустымКоличеством(ЭтапПроизводства);
	Документы.ЭтапПроизводства2_2.ЗаполнитьРасходМатериаловИРаботПоДаннымОбеспечения(ЭтапПроизводства);
КонецПроцедуры

Функция СоотношениеРасходаМатериаловСНормативами(ЭтапПроизводства, МатериалыИУслугиПотребность,
						ТолькоРасхождения = Истина, ВключатьМатериалыКОбеспечению = Истина) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбеспечениеМатериаламиИРаботами.Номенклатура КАК Номенклатура,
	|	ОбеспечениеМатериаламиИРаботами.Характеристика КАК Характеристика,
	|	ОбеспечениеМатериаламиИРаботами.Склад КАК Склад,
	|	ОбеспечениеМатериаламиИРаботами.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	ОбеспечениеМатериаламиИРаботами.КоличествоУпаковок КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ОбеспечениеМатериаламиИРаботами
	|ИЗ
	|	&ОбеспечениеМатериаламиИРаботами КАК ОбеспечениеМатериаламиИРаботами
	|ГДЕ
	|	НЕ ОбеспечениеМатериаламиИРаботами.Отменено
	|	И (&ВключатьМатериалыКОбеспечению
	|			ИЛИ ОбеспечениеМатериаламиИРаботами.ВариантОбеспечения В (&ВариантыОбеспеченияКОтгрузке))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МатериалыИУслугиПотребность.Номенклатура КАК Номенклатура,
	|	МатериалыИУслугиПотребность.Характеристика КАК Характеристика,
	|	МатериалыИУслугиПотребность.КоличествоУпаковок КАК КоличествоУпаковок
	|ПОМЕСТИТЬ МатериалыИУслугиПотребность
	|ИЗ
	|	&МатериалыИУслугиПотребность КАК МатериалыИУслугиПотребность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбеспечениеМатериаламиИРаботами.Номенклатура КАК Номенклатура,
	|	ОбеспечениеМатериаламиИРаботами.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбеспечениеМатериаламиИРаботами.Склад) = 1
	|			ТОГДА МАКСИМУМ(ОбеспечениеМатериаламиИРаботами.Склад)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Склад,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОбеспечениеМатериаламиИРаботами.СтатьяКалькуляции) = 1
	|			ТОГДА МАКСИМУМ(ОбеспечениеМатериаламиИРаботами.СтатьяКалькуляции)
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СтатьяКалькуляции
	|ПОМЕСТИТЬ СкладыОбеспечения
	|ИЗ
	|	ОбеспечениеМатериаламиИРаботами КАК ОбеспечениеМатериаламиИРаботами
	|
	|СГРУППИРОВАТЬ ПО
	|	ОбеспечениеМатериаламиИРаботами.Номенклатура,
	|	ОбеспечениеМатериаламиИРаботами.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбеспечениеМатериаламиИРаботами.Номенклатура КАК Номенклатура,
	|	ОбеспечениеМатериаламиИРаботами.Характеристика КАК Характеристика,
	|	ОбеспечениеМатериаламиИРаботами.КоличествоУпаковок КАК КоличествоОбеспечение,
	|	0 КАК КоличествоПотребность
	|ПОМЕСТИТЬ РасхожденияПредварительно
	|ИЗ
	|	ОбеспечениеМатериаламиИРаботами КАК ОбеспечениеМатериаламиИРаботами
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МатериалыИУслугиПотребность.Номенклатура,
	|	МатериалыИУслугиПотребность.Характеристика,
	|	0,
	|	МатериалыИУслугиПотребность.КоличествоУпаковок
	|ИЗ
	|	МатериалыИУслугиПотребность КАК МатериалыИУслугиПотребность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ЭтапПроизводства КАК ЭтапПроизводства,
	|	&Спецификация КАК Спецификация,
	|	РасхожденияПредварительно.Номенклатура КАК Номенклатура,
	|	РасхожденияПредварительно.Характеристика КАК Характеристика,
	|	СкладыОбеспечения.Склад КАК Склад,
	|	СкладыОбеспечения.СтатьяКалькуляции КАК СтатьяКалькуляции,
	|	СУММА(РасхожденияПредварительно.КоличествоОбеспечение) КАК КоличествоОбеспечение,
	|	СУММА(РасхожденияПредварительно.КоличествоПотребность) КАК КоличествоПотребность,
	|	СУММА(РасхожденияПредварительно.КоличествоОбеспечение) - СУММА(РасхожденияПредварительно.КоличествоПотребность) КАК КоличествоРасхождение
	|ИЗ
	|	РасхожденияПредварительно КАК РасхожденияПредварительно
	|		ЛЕВОЕ СОЕДИНЕНИЕ СкладыОбеспечения КАК СкладыОбеспечения
	|		ПО РасхожденияПредварительно.Номенклатура = СкладыОбеспечения.Номенклатура
	|			И РасхожденияПредварительно.Характеристика = СкладыОбеспечения.Характеристика
	|
	|СГРУППИРОВАТЬ ПО
	|	РасхожденияПредварительно.Номенклатура,
	|	РасхожденияПредварительно.Характеристика,
	|	СкладыОбеспечения.Склад,
	|	СкладыОбеспечения.СтатьяКалькуляции
	|
	|ИМЕЮЩИЕ
	|	(НЕ &ТолькоРасхождения
	|		ИЛИ СУММА(РасхожденияПредварительно.КоличествоОбеспечение) <> 0
	|			И СУММА(РасхожденияПредварительно.КоличествоОбеспечение) <> СУММА(РасхожденияПредварительно.КоличествоПотребность))";
	
	Если ТипЗнч(ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами) = Тип("ТаблицаЗначений") Тогда
		ОбеспечениеМатериаламиИРаботами = ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами;
	Иначе
		ОбеспечениеМатериаламиИРаботами = ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами.Выгрузить(,
				"Номенклатура, Характеристика, Склад, ВариантОбеспечения, СтатьяКалькуляции, КоличествоУпаковок, Отменено");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ОбеспечениеМатериаламиИРаботами", ОбеспечениеМатериаламиИРаботами);
	Запрос.УстановитьПараметр("МатериалыИУслугиПотребность", МатериалыИУслугиПотребность);
	Запрос.УстановитьПараметр("ЭтапПроизводства", ЭтапПроизводства.Ссылка);
	Запрос.УстановитьПараметр("Спецификация", ЭтапПроизводства.Спецификация);
	Запрос.УстановитьПараметр("ТолькоРасхождения", ТолькоРасхождения);
	
	Запрос.УстановитьПараметр("ВключатьМатериалыКОбеспечению", ВключатьМатериалыКОбеспечению);
	
	ВариантыОбеспеченияКОтгрузке = Новый Массив;
	ВариантыОбеспеченияКОтгрузке.Добавить(Перечисления.ВариантыОбеспечения.Отгрузить);
	Запрос.УстановитьПараметр("ВариантыОбеспеченияКОтгрузке", ВариантыОбеспеченияКОтгрузке);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();
КонецФункции

Функция ПотребностьСогласноСпецификации(ЭтапПроизводства) Экспорт
	Если Не ЗначениеЗаполнено(ЭтапПроизводства.Спецификация) Тогда
		ТекстСообщения = НСтр("ru = 'Для выпускаемой продукции не задана спецификация'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Неопределено;
	КонецЕсли;
	
	ВыпускаемаяПродукция = ВыпускаемаяПродукция(ЭтапПроизводства);
	Если ВыпускаемаяПродукция = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'В рамках одного этапа производства должен выпускаться один вид продукции. Сценарний не поддерживается'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаВыходныеИзделия = ТаблицаВыходныеИзделияРасчетОбеспечения(ВыпускаемаяПродукция);
	ПараметрыВыборкиДанных = Справочники.РесурсныеСпецификации.ПараметрыВыборкиДанных("МатериалыИУслуги");
	
	ДанныеСпецификации = Справочники.РесурсныеСпецификации.ДанныеСпецификацииПоСпискуНоменклатуры(ТаблицаВыходныеИзделия, ПараметрыВыборкиДанных)[0];
	
	Возврат ДанныеСпецификации.МатериалыИУслуги;
КонецФункции

Процедура ВыполнитьОтменуНеобеспеченныхЗаказовМатериалов(Назначение) Экспорт
	Если Не ЗначениеЗаполнено(Назначение) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено назначение обособления товаров, операция невозможна.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказыМатериаловОстатки.Распоряжение КАК Распоряжение,
	|	ЗаказыМатериаловОстатки.КодСтроки КАК КодСтроки,
	|	ЗаказыМатериаловОстатки.ЗаказаноОстаток КАК ЗаказаноОстаток
	|ИЗ
	|	РегистрНакопления.ЗаказыМатериаловВПроизводство.Остатки(
	|			,
	|			Назначение = &Назначение
	|				И ТИПЗНАЧЕНИЯ(Распоряжение) = ТИП(Документ.ЗаказМатериаловВПроизводство)
	|				И КодСтроки <> 0) КАК ЗаказыМатериаловОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Распоряжение";
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	
	ШаблонОшибкиЗаблокировать             = НСтр("ru = 'Не удалось заблокировать %1. %2'");
	ШаблонОшибкиЗаписать                  = НСтр("ru = 'Не удалось записать %1. %2'");
	ШаблонСообщенияВыполненаКорректировка = НСтр("ru = 'Выполнена отмена строк заказа %1'");
	
	Пока Выборка.СледующийПоЗначениюПоля("Распоряжение") Цикл
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Распоряжение);
		Исключение
			ТекстОшибки = СтрШаблон(ШаблонОшибкиЗаблокировать, Выборка.Распоряжение, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Продолжить;
		КонецПопытки;
		
		ДокументОбъект = Выборка.Распоряжение.ПолучитьОбъект();
		
		КэшированныеЗначения = Неопределено;
		Пока Выборка.Следующий() Цикл
			ОтменитьСтрокуЗаказаМатериаловВПроизводство(ДокументОбъект, Выборка.КодСтроки, Выборка.ЗаказаноОстаток, КэшированныеЗначения);
		КонецЦикла;
		
		Попытка
			Если ЕстьНеОтмененныеСтрокиЗаказаМатериаловВПроизводство(ДокументОбъект) Тогда
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				ДокументОбъект.ПометкаУдаления = Истина;
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
			
			ТекстСообщения = СтрШаблон(ШаблонСообщенияВыполненаКорректировка, Выборка.Распоряжение);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
		Исключение
			ТекстОшибки = СтрШаблон(ШаблонОшибкиЗаписать, Выборка.Распоряжение, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

Функция ДатаПроизводстваПродукции(ЭтапПроизводстваОбъект) Экспорт
	ОтборВыходныеИзделия   = Новый Структура("Отменено", Ложь);
	ТаблицаВыходныеИзделия = ЭтапПроизводстваОбъект.ВыходныеИзделия.Выгрузить(ОтборВыходныеИзделия, "ДатаПроизводства");
	
	ТаблицаВыходныеИзделия.Свернуть("ДатаПроизводства");
	Если ТаблицаВыходныеИзделия.Количество() = 1 Тогда
		Возврат ТаблицаВыходныеИзделия[0].ДатаПроизводства;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ДоступноРедактированиеДокумента(ЭтапПроизводстваСсылка) Экспорт
	Если Не ЗначениеЗаполнено(ЭтапПроизводстваСсылка)
		Или Пользователи.ЭтоПолноправныйПользователь() Тогда
		Возврат Истина;
	КонецЕсли;
	
	СтатусЭтапаПроизводства = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтапПроизводстваСсылка, "Статус");
	Если СтатусЭтапаПроизводства <> Перечисления.СтатусыЭтаповПроизводства2_2.Завершен Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.битОтчетОПроизводствеЕГАИС)
		Или Пользователи.РолиДоступны("бг_КорректировкаСписанияМатериаловЗавершенныхЭтаповПроизводства", , Ложь) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

Функция ОтправленОтчетВЕГАИС(ЭтапПроизводстваСсылка) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетОПроизводствеЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.битОтчетОПроизводствеЕГАИС КАК ОтчетОПроизводствеЕГАИС
	|ГДЕ
	|	ОтчетОПроизводствеЕГАИС.ДокументОснование = &ДокументОснование
	|	И Не ОтчетОПроизводствеЕГАИС.ПометкаУдаления";
	Запрос.УстановитьПараметр("ДокументОснование", ЭтапПроизводстваСсылка);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
КонецФункции

Процедура ВыполнитьКонтрольИзмененияВыходныхИзделий(ЭтапПроизводстваОбъект, Отказ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ВыходныеИзделия.Произведено КАК Произведено,
	|	ВыходныеИзделия.ДатаПроизводства КАК ДатаПроизводства,
	|	ВыходныеИзделия.Серия КАК Серия,
	|	ВыходныеИзделия.Отменено КАК Отменено,
	|	ВыходныеИзделия.Количество КАК Количество
	|ПОМЕСТИТЬ ВыходныеИзделия
	|ИЗ
	|	&ВыходныеИзделия КАК ВыходныеИзделия
	|ГДЕ
	|	&Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Завершен)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ЭтапВыходныеИзделия.Произведено КАК Произведено,
	|	ЭтапВыходныеИзделия.ДатаПроизводства КАК ДатаПроизводства,
	|	ЭтапВыходныеИзделия.Серия КАК Серия,
	|	ЭтапВыходныеИзделия.Отменено КАК Отменено,
	|	ЭтапВыходныеИзделия.Количество КАК Количество
	|ПОМЕСТИТЬ КонтрольВыходныеИзделия
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ЭтапВыходныеИзделия
	|ГДЕ
	|	ЭтапВыходныеИзделия.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВыходныеИзделия.Номенклатура,
	|	ВыходныеИзделия.Произведено,
	|	ВыходныеИзделия.ДатаПроизводства,
	|	ВыходныеИзделия.Серия,
	|	ВыходныеИзделия.Отменено,
	|	-ВыходныеИзделия.Количество
	|ИЗ
	|	ВыходныеИзделия КАК ВыходныеИзделия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрольВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	КонтрольВыходныеИзделия.Произведено КАК Произведено,
	|	КонтрольВыходныеИзделия.ДатаПроизводства КАК ДатаПроизводства,
	|	КонтрольВыходныеИзделия.Серия КАК Серия,
	|	КонтрольВыходныеИзделия.Отменено КАК Отменено,
	|	СУММА(КонтрольВыходныеИзделия.Количество) КАК Количество
	|ИЗ
	|	КонтрольВыходныеИзделия КАК КонтрольВыходныеИзделия
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрольВыходныеИзделия.Номенклатура,
	|	КонтрольВыходныеИзделия.Произведено,
	|	КонтрольВыходныеИзделия.ДатаПроизводства,
	|	КонтрольВыходныеИзделия.Серия,
	|	КонтрольВыходныеИзделия.Отменено
	|
	|ИМЕЮЩИЕ
	|	СУММА(КонтрольВыходныеИзделия.Количество) <> 0";
	
	Запрос.УстановитьПараметр("Ссылка", ЭтапПроизводстваОбъект.Ссылка);
	Запрос.УстановитьПараметр("Статус", ЭтапПроизводстваОбъект.Статус);
	Запрос.УстановитьПараметр(
			"ВыходныеИзделия",
			ЭтапПроизводстваОбъект.ВыходныеИзделия.Выгрузить(, "Номенклатура, Произведено, ДатаПроизводства, Серия, Отменено, Количество"));
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru = 'Изменены данные по выпуску продукции: %1, редактирование документа запрещено.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Номенклатура);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЦикла;
КонецПроцедуры

Процедура ВыполнитьКонтрольИзмененияОбеспеченияМатериалами(ЭтапПроизводстваОбъект, Отказ, ВидыНоменклатурыОтбор = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Обеспечение.Номенклатура КАК Номенклатура,
	|	Обеспечение.Характеристика КАК Характеристика,
	|	Обеспечение.Склад КАК Склад,
	|	Обеспечение.Назначение КАК Назначение,
	|	Обеспечение.Серия КАК Серия,
	|	Обеспечение.Отменено КАК Отменено,
	|	Обеспечение.ВариантОбеспечения КАК ВариантОбеспечения,
	|	Обеспечение.Количество КАК Количество
	|ПОМЕСТИТЬ Обеспечение
	|ИЗ
	|	&Обеспечение КАК Обеспечение
	|ГДЕ
	|	&Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Завершен)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭтапОбеспечениеМатериалами.Номенклатура КАК Номенклатура,
	|	ЭтапОбеспечениеМатериалами.Характеристика КАК Характеристика,
	|	ЭтапОбеспечениеМатериалами.Склад КАК Склад,
	|	ЭтапОбеспечениеМатериалами.Назначение КАК Назначение,
	|	ЭтапОбеспечениеМатериалами.Серия КАК Серия,
	|	ЭтапОбеспечениеМатериалами.Отменено КАК Отменено,
	|	ЭтапОбеспечениеМатериалами.ВариантОбеспечения КАК ВариантОбеспечения,
	|	ЭтапОбеспечениеМатериалами.Количество КАК Количество
	|ПОМЕСТИТЬ КонтрольОбеспечения
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ОбеспечениеМатериаламиИРаботами КАК ЭтапОбеспечениеМатериалами
	|ГДЕ
	|	ЭтапОбеспечениеМатериалами.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Обеспечение.Номенклатура,
	|	Обеспечение.Характеристика,
	|	Обеспечение.Склад,
	|	Обеспечение.Назначение,
	|	Обеспечение.Серия,
	|	Обеспечение.Отменено,
	|	Обеспечение.ВариантОбеспечения,
	|	-Обеспечение.Количество
	|ИЗ
	|	Обеспечение КАК Обеспечение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрольОбеспечения.Номенклатура КАК Номенклатура,
	|	КонтрольОбеспечения.Характеристика КАК Характеристика,
	|	КонтрольОбеспечения.Склад КАК Склад,
	|	КонтрольОбеспечения.Назначение КАК Назначение,
	|	КонтрольОбеспечения.Серия КАК Серия,
	|	КонтрольОбеспечения.Отменено КАК Отменено,
	|	КонтрольОбеспечения.ВариантОбеспечения КАК ВариантОбеспечения,
	|	СУММА(КонтрольОбеспечения.Количество) КАК Количество
	|ИЗ
	|	КонтрольОбеспечения КАК КонтрольОбеспечения
	|ГДЕ
	|	(НЕ &ОтборПоВидамНоменклатуры
	|			ИЛИ КонтрольОбеспечения.Номенклатура.ВидНоменклатуры В (&ВидыНоменклатуры))
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрольОбеспечения.Номенклатура,
	|	КонтрольОбеспечения.Характеристика,
	|	КонтрольОбеспечения.Склад,
	|	КонтрольОбеспечения.Назначение,
	|	КонтрольОбеспечения.Серия,
	|	КонтрольОбеспечения.Отменено,
	|	КонтрольОбеспечения.ВариантОбеспечения
	|
	|ИМЕЮЩИЕ
	|	СУММА(КонтрольОбеспечения.Количество) <> 0";
	
	Запрос.УстановитьПараметр("Ссылка", ЭтапПроизводстваОбъект.Ссылка);
	Запрос.УстановитьПараметр("Статус", ЭтапПроизводстваОбъект.Статус);
	Запрос.УстановитьПараметр(
			"Обеспечение",
			ЭтапПроизводстваОбъект.ОбеспечениеМатериаламиИРаботами.Выгрузить(, "Номенклатура, Характеристика, Склад, Назначение, Серия, Отменено, ВариантОбеспечения, Количество"));
	
	Запрос.УстановитьПараметр("ОтборПоВидамНоменклатуры", ВидыНоменклатурыОтбор <> Неопределено);
	Если ВидыНоменклатурыОтбор = Неопределено Тогда
		Запрос.УстановитьПараметр("ВидыНоменклатуры", Новый Массив);
	Иначе
		Запрос.УстановитьПараметр("ВидыНоменклатуры", ВидыНоменклатурыОтбор);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru = 'Изменены данные по списанию материала: %1, редактирование документа запрещено.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Номенклатура);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЦикла;
КонецПроцедуры

Функция ЭтапыПроизводстваПоДатеВыпуска(ДатаНачала, ДатаОкончания) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЭтапПроизводства.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ЭтапПроизводства
	|ГДЕ
	|	ЭтапПроизводства.Проведен
	|	И ЭтапПроизводства.ДатаПроизводства МЕЖДУ &ДатаНачала И &ДатаОкончания";
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаВыходныеИзделияРасчетОбеспечения(ВыпускаемаяПродукция)
	ТаблицаСписокНоменклатуры = Справочники.РесурсныеСпецификации.СписокНоменклатуры();
	
	НоваяСтрокаСписокНоменклатуры = ТаблицаСписокНоменклатуры.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрокаСписокНоменклатуры, ВыпускаемаяПродукция);
	
	Возврат ТаблицаСписокНоменклатуры;
КонецФункции

Функция ВыпускаемаяПродукция(ЭтапПроизводства)
	Если ТипЗнч(ЭтапПроизводства.ВыходныеИзделия) = Тип("ТаблицаЗначений") Тогда
		ТаблицаВыходныеИзделия = ЭтапПроизводства.ВыходныеИзделия;
	Иначе
		Отбор = Новый Структура("Отменено", Ложь);
		
		ТаблицаВыходныеИзделия = ЭтапПроизводства.ВыходныеИзделия.Выгрузить(Отбор, "Номенклатура, Характеристика, Количество");
		ТаблицаВыходныеИзделия.Свернуть("Номенклатура, Характеристика", "Количество");
	КонецЕсли;
	
	Если ТаблицаВыходныеИзделия.Количество() = 1 Тогда
		Возврат Новый Структура("Спецификация, Номенклатура, Характеристика, Количество",
					ЭтапПроизводства.Спецификация,
					ТаблицаВыходныеИзделия[0].Номенклатура,
					ТаблицаВыходныеИзделия[0].Характеристика,
					ТаблицаВыходныеИзделия[0].Количество);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Процедура ПерезаполнитьОбеспечениеМатериалов(ЭтапПроизводства, МатериалыИУслугиПотребность)
	РасхожденияККорректировкеПотребности = СоотношениеРасходаМатериаловСНормативами(ЭтапПроизводства, МатериалыИУслугиПотребность, Ложь);
	
	КэшированныеЗначения = Неопределено;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПроизводствоКлиентСервер.ПараметрыПересчетаКоличестваЕдиниц());
	
	Для Каждого СтрокаРасхождение Из РасхожденияККорректировкеПотребности Цикл
		ОтборСтроки = Новый Структура("Номенклатура, Характеристика",
						СтрокаРасхождение.Номенклатура, СтрокаРасхождение.Характеристика);
		
		СтрокиОбеспечение = ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами.НайтиСтроки(ОтборСтроки);
		
		НомерСтроки     = 1;
		КоличествоСтрок = СтрокиОбеспечение.Количество();
		
		Для Каждого СтрокаОбеспечение Из СтрокиОбеспечение Цикл
			Если КоличествоСтрок = 1
				Или НомерСтроки = КоличествоСтрок Тогда
				СтрокаОбеспечение.КоличествоУпаковок = СтрокаРасхождение.КоличествоПотребность;
			Иначе
				СтрокаОбеспечение.КоличествоУпаковок = ?(СтрокаОбеспечение.КоличествоУпаковок >= СтрокаРасхождение.КоличествоПотребность,
						СтрокаРасхождение.КоличествоПотребность, СтрокаОбеспечение.КоличествоУпаковок);
				СтрокаРасхождение.КоличествоПотребность = СтрокаРасхождение.КоличествоПотребность - СтрокаОбеспечение.КоличествоУпаковок;
			КонецЕсли;
			
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаОбеспечение, СтруктураДействий, КэшированныеЗначения);
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ОчиститьКорректировкиРасходаМатериалов(ЭтапПроизводства)
	ЭтапПроизводства.ЭкономияМатериалов.Очистить();
	ЭтапПроизводства.РасходМатериаловИРабот.Очистить();
	
	ОтборСтрокиДополнительныйРасход = Новый Структура("бг_ДополнительныйРасход", Истина);
	СтрокиДополнительныйРасход = ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами.НайтиСтроки(ОтборСтрокиДополнительныйРасход);
	Для Каждого СтрокаДополнительныйРасход Из СтрокиДополнительныйРасход Цикл
		ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами.Удалить(СтрокаДополнительныйРасход);
	КонецЦикла;
КонецПроцедуры

Процедура ОтменитьСтрокиОбеспеченияСПустымКоличеством(ЭтапПроизводства)
	ПричинаОтменыСтрокОбеспечения = бг_КонстантыПовтИсп.ЗначениеКонстанты("ПричинаОтменыОбеспеченияМатериаловВПроизводствеЕслиНеТребуется");
	
	ОтборСтроки = Новый Структура("КоличествоУпаковок", 0);
	СтрокиОтменить = ЭтапПроизводства.ОбеспечениеМатериаламиИРаботами.НайтиСтроки(ОтборСтроки);
	Для Каждого СтрокаОтменить Из СтрокиОтменить Цикл
		СтрокаОтменить.Отменено = Истина;
		СтрокаОтменить.ПричинаОтмены = ПричинаОтменыСтрокОбеспечения;
	КонецЦикла;
КонецПроцедуры

Процедура ОтменитьСтрокуЗаказаМатериаловВПроизводство(ЗаказМатериаловОбъект, КодСтроки, КоличествоОтменить, КэшированныеЗначения)
	ОтборСтроки = Новый Структура("КодСтроки, Отменено", КодСтроки, Ложь);
	СтрокиЗаказМатериалов = ЗаказМатериаловОбъект.Товары.НайтиСтроки(ОтборСтроки);
	
	Если СтрокиЗаказМатериалов.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЗаказа = СтрокиЗаказМатериалов[0];
	
	Если СтрокаЗаказа.Количество <= КоличествоОтменить Тогда
		СтрокаЗаказа.Отменено = Истина;
		Возврат;
	КонецЕсли;
	
	ОтмененнаяСтрока = ЗаказМатериаловОбъект.Товары.Добавить();
	ЗаполнитьЗначенияСвойств(ОтмененнаяСтрока, СтрокаЗаказа);
	ОтмененнаяСтрока.Количество = КоличествоОтменить;
	ОтмененнаяСтрока.КодСтроки  = 0;
	ОтмененнаяСтрока.Отменено   = Истина;
	
	СтрокаЗаказа.Количество = СтрокаЗаказа.Количество - ОтмененнаяСтрока.Количество;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаЗаказа, СтруктураДействий, КэшированныеЗначения);
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ОтмененнаяСтрока, СтруктураДействий, КэшированныеЗначения);
КонецПроцедуры

Функция ЕстьНеОтмененныеСтрокиЗаказаМатериаловВПроизводство(ЗаказМатериаловВПроизводство)
	Возврат ЗаказМатериаловВПроизводство.Товары.Найти(Ложь, "Отменено") <> Неопределено;
КонецФункции

#КонецОбласти
