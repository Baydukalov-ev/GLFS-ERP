
#Область ПоискНоменклатурыКонтрагентов

// Возвращает номенклатуру контрагента найденную по номенклатуре информационной базы в строке таблицы.
//
// Параметры:
//  ВладелецНоменклатуры - ОпределяемыйТип.ВладелецНоменклатурыБЭД - владелец номенклатуры.
//  Номенклатура      	 - СправочникСсылка.Номенклатура. 
//
// Возвращаемое значение:
// ТаблицаЗначений - Если номенклатура контрагента не найдена возвращается Неопределено.
Функция бг_ДанныеНоменклатурыКонтрагентаПоНоменклатуре(Знач ВладелецНоменклатуры, Знач Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВладелецНоменклатуры"   , ВладелецНоменклатуры);
	Запрос.УстановитьПараметр("Номенклатура"           , Номенклатура);

	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НоменклатураКонтрагентов.бг_КодНоменклатурыКонтрагента КАК бг_КодНоменклатурыКонтрагента,
	|	НоменклатураКонтрагентов.Артикул КАК Артикул,
	|	НоменклатураКонтрагентов.Код КАК Код,
	|	НоменклатураКонтрагентов.Характеристика КАК Характеристика,
	|	НоменклатураКонтрагентов.Упаковка КАК Упаковка,
	|	НоменклатураКонтрагентов.Представление КАК Представление
	|ИЗ
	|	Справочник.НоменклатураКонтрагентов КАК НоменклатураКонтрагентов
	|ГДЕ
	|	НоменклатураКонтрагентов.ВладелецНоменклатуры = &ВладелецНоменклатуры
	|	И НоменклатураКонтрагентов.Номенклатура = &Номенклатура
	|	И НЕ НоменклатураКонтрагентов.ПометкаУдаления
	|	И НЕ НоменклатураКонтрагентов.Недействителен";
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Результат.Выгрузить();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти